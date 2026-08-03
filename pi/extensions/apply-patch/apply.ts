// Dotfiles-managed Pi extension.

/**
 * Apply parsed V4A hunks to the filesystem.
 *
 * Ported from openai/codex `codex-rs/apply-patch/src/lib.rs`
 * (`apply_hunks_to_files`, `derive_new_contents_from_chunks`,
 * `compute_replacements`, `apply_replacements`).
 *
 * Two deliberate deviations from the codex reference, both for data safety:
 *
 *   1. `*** Move to: <same path>` is rejected before any write. Codex writes
 *      the new content then removes the (same) source path, deleting the file;
 *      we refuse so no data is lost.
 *   2. `*** Add File` / `*** Move to` that land on an existing file overwrite it
 *      (matching codex scenario 011/010, which Codex-trained models expect),
 *      but the overwrite is recorded in the result (`overwritten` / `O <path>`
 *      summary lines) so the caller is not silently clobbering a file.
 *
 * Apply is best-effort and non-transactional, again matching codex: if a later
 * hunk fails, earlier hunks stay on disk. The error message lists the files
 * already modified so the model can re-read them instead of double-applying.
 */

import { mkdir, readFile, rm, stat, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";

import { seekSequence } from "./seek";
import type {
  AffectedPaths,
  ApplyPatchResult,
  FileChange,
  Hunk,
  UpdateFileChunk,
} from "./types";

export async function applyHunks(
  hunks: Hunk[],
  cwd: string,
  onProgress?: (partial: ApplyPatchResult) => void,
): Promise<ApplyPatchResult> {
  if (hunks.length === 0) {
    throw new Error("No files were modified.");
  }

  const added: string[] = [];
  const modified: string[] = [];
  const deleted: string[] = [];
  const overwritten: string[] = [];
  const fileChanges: FileChange[] = [];
  // Paths already committed to disk before the current hunk. If a later hunk
  // fails, these are the files whose contents changed before the error, so the
  // caller (and the model) can tell the patch was partially applied rather
  // than rolled back. V4A apply is best-effort: committed hunks stay on disk.
  const appliedBefore: string[] = [];

  for (const hunk of hunks) {
    const affectedPath = hunkPath(hunk);
    try {
      if (hunk.type === "add") {
        const abs = resolve(cwd, hunk.path);
        const exists = await pathExists(abs);
        const before = exists ? await readFileText(abs) : "";
        if (exists) overwritten.push(affectedPath);
        await writeFileWithDirs(abs, hunk.contents);
        added.push(affectedPath);
        fileChanges.push({ path: affectedPath, before, after: hunk.contents });
      } else if (hunk.type === "delete") {
        const abs = resolve(cwd, hunk.path);
        await ensureNotDirectory(abs);
        const before = await readFileText(abs);
        await rm(abs, { force: false });
        deleted.push(affectedPath);
        fileChanges.push({ path: affectedPath, before, after: "" });
      } else {
        const abs = resolve(cwd, hunk.path);
        const original = await readFileText(abs);
        const next = deriveNewContents(original, hunk.chunks, abs);
        if (hunk.movePath) {
          const dest = resolve(cwd, hunk.movePath);
          // Issue A: a Move to the same path writes the new content then
          // removes it (dest === abs), silently deleting the file. Reject
          // before any write so no data is lost. Use Update File without a
          // Move to edit in place.
          if (dest === abs) {
            throw new Error(
              `Move to: '${hunk.movePath}' is the same as the source path '${hunk.path}'. This would delete the file. Use Update File without a Move to instead.`,
            );
          }
          const destExists = await pathExists(dest);
          const destBefore = destExists ? await readFileText(dest) : "";
          if (destExists) {
            overwritten.push(hunk.movePath);
          }
          await writeFileWithDirs(dest, next);
          await ensureNotDirectory(abs);
          await rm(abs, { force: false });
          fileChanges.push({ path: hunk.path, before: original, after: "" });
          fileChanges.push({
            path: hunk.movePath,
            before: destBefore,
            after: next,
          });
        } else {
          await writeFileWithDirs(abs, next);
          fileChanges.push({
            path: affectedPath,
            before: original,
            after: next,
          });
        }
        modified.push(affectedPath);
      }
    } catch (error) {
      // Issue E: earlier hunks are already on disk; surface them so the model
      // knows the patch was partially applied and does not blindly retry the
      // whole patch (which would double-apply the committed hunks).
      if (appliedBefore.length > 0) {
        const list = appliedBefore.join(", ");
        const msg = error instanceof Error ? error.message : String(error);
        throw new Error(
          `${msg}\nFiles already modified before this error: ${list}. The patch was partially applied; re-reading those files before retrying.`,
        );
      }
      throw error;
    }
    appliedBefore.push(affectedPath);
    // Stream a partial result after each committed hunk so the UI can render
    // files as they are edited/created instead of waiting for the full patch.
    // Snapshot the accumulated arrays: they keep mutating as later hunks run,
    // and a consumer may hold a partial past the next tick.
    onProgress?.({
      affected: {
        added: [...added],
        modified: [...modified],
        deleted: [...deleted],
        overwritten: [...overwritten],
      },
      summary: formatSummary({ added, modified, deleted, overwritten }),
      fileChanges: [...fileChanges],
    });
  }

  const affected: AffectedPaths = { added, modified, deleted, overwritten };
  return {
    affected,
    summary: formatSummary(affected),
    fileChanges,
  };
}

function hunkPath(hunk: Hunk): string {
  if (hunk.type === "update" && hunk.movePath) return hunk.movePath;
  return hunk.path;
}

async function writeFileWithDirs(
  absPath: string,
  content: string,
): Promise<void> {
  try {
    await writeFile(absPath, content, "utf8");
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      await mkdir(dirname(absPath), { recursive: true });
      await writeFile(absPath, content, "utf8");
      return;
    }
    throw error;
  }
}

async function ensureNotDirectory(absPath: string): Promise<void> {
  const st = await stat(absPath);
  if (st.isDirectory()) {
    throw new Error(`${absPath} is a directory, not a file.`);
  }
}

/** True if `absPath` exists (file or directory). Swallows errors. */
async function pathExists(absPath: string): Promise<boolean> {
  try {
    await stat(absPath);
    return true;
  } catch {
    return false;
  }
}

async function readFileText(absPath: string): Promise<string> {
  try {
    return await readFile(absPath, "utf8");
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      throw new Error(`Failed to read file to update ${absPath}`);
    }
    throw error;
  }
}

/** Compute new file contents after applying `chunks` to `original`. */
export function deriveNewContents(
  original: string,
  chunks: UpdateFileChunk[],
  pathText: string,
): string {
  const originalLines = original.split("\n").map(String);
  // Drop the trailing empty element produced by the final newline so line
  // counts match standard `diff` behaviour.
  if (
    originalLines.length > 0 &&
    originalLines[originalLines.length - 1] === ""
  ) {
    originalLines.pop();
  }

  const replacements = computeReplacements(originalLines, pathText, chunks);
  let newLines = applyReplacements(originalLines, replacements);
  if (newLines.length === 0 || newLines[newLines.length - 1] !== "") {
    newLines = [...newLines, ""];
  }
  return newLines.join("\n");
}

interface Replacement {
  startIndex: number;
  oldLen: number;
  newLines: string[];
}

function computeReplacements(
  originalLines: string[],
  pathText: string,
  chunks: UpdateFileChunk[],
): Replacement[] {
  const replacements: Replacement[] = [];
  let lineIndex = 0;

  for (const chunk of chunks) {
    if (chunk.changeContext !== null) {
      const idx = seekSequence(
        originalLines,
        [chunk.changeContext],
        lineIndex,
        false,
      );
      if (idx === undefined) {
        throw new Error(
          `Failed to find context '${chunk.changeContext}' in ${pathText}`,
        );
      }
      lineIndex = idx + 1;
    }

    if (chunk.oldLines.length === 0) {
      // Pure addition: insert at end (or just before a trailing empty line).
      const insertionIdx =
        originalLines.length > 0 &&
        originalLines[originalLines.length - 1] === ""
          ? originalLines.length - 1
          : originalLines.length;
      replacements.push({
        startIndex: insertionIdx,
        oldLen: 0,
        newLines: chunk.newLines,
      });
      continue;
    }

    let pattern = chunk.oldLines;
    let newSlice = chunk.newLines;
    let found = seekSequence(
      originalLines,
      pattern,
      lineIndex,
      chunk.isEndOfFile,
    );

    if (
      found === undefined &&
      pattern.length > 0 &&
      pattern[pattern.length - 1] === ""
    ) {
      pattern = pattern.slice(0, -1);
      if (newSlice.length > 0 && newSlice[newSlice.length - 1] === "") {
        newSlice = newSlice.slice(0, -1);
      }
      found = seekSequence(
        originalLines,
        pattern,
        lineIndex,
        chunk.isEndOfFile,
      );
    }

    if (found === undefined) {
      throw new Error(
        `Failed to find expected lines in ${pathText}:\n${chunk.oldLines.join("\n")}`,
      );
    }

    replacements.push({
      startIndex: found,
      oldLen: pattern.length,
      newLines: newSlice,
    });
    lineIndex = found + pattern.length;
  }

  replacements.sort((a, b) => a.startIndex - b.startIndex);
  return replacements;
}

function applyReplacements(
  lines: string[],
  replacements: Replacement[],
): string[] {
  // Apply in descending index order so earlier replacements don't shift the
  // positions of later ones. `replacements` is sorted ascending, so walk it in
  // reverse.
  for (let r = replacements.length - 1; r >= 0; r--) {
    const rep = replacements[r];
    if (!rep) continue;
    const { startIndex, oldLen, newLines } = rep;
    const current = startIndex;
    for (let i = 0; i < oldLen; i++) {
      if (current < lines.length) {
        lines.splice(current, 1);
      }
    }
    for (let offset = 0; offset < newLines.length; offset++) {
      lines.splice(current + offset, 0, newLines[offset] ?? "");
    }
  }
  return lines;
}

function formatSummary(affected: AffectedPaths): string[] {
  const lines: string[] = [];
  for (const p of affected.added) lines.push(`A ${p}`);
  for (const p of affected.modified) lines.push(`M ${p}`);
  for (const p of affected.deleted) lines.push(`D ${p}`);
  // Overwrites are a footgun signal: an Add File or Move to landed on a path
  // that already existed and replaced its contents. Surface them so the
  // caller can notice an accidental clobber (codex itself records
  // `overwritten_content` in its delta for the same reason).
  for (const p of affected.overwritten)
    lines.push(`O ${p} (overwrote existing)`);
  return lines;
}
