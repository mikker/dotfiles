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

import { mkdir, readFile, realpath, rm, stat, writeFile } from "node:fs/promises";
import { dirname, isAbsolute, resolve, win32 } from "node:path";
import { withFileMutationQueue } from "@earendil-works/pi-coding-agent";

import { seekSequence } from "./seek";
import type {
  AffectedPaths,
  ApplyPatchResult,
  FileChange,
  Hunk,
  UpdateFileChunk,
} from "./types";

export class ApplyPatchError extends Error {
  constructor(message: string, readonly partial: ApplyPatchResult) {
    super(message);
    this.name = "ApplyPatchError";
  }
}

export async function applyHunks(
  hunks: Hunk[],
  cwd: string,
  onProgress?: (partial: ApplyPatchResult) => void,
  signal?: AbortSignal,
): Promise<ApplyPatchResult> {
  const added: string[] = [];
  const modified: string[] = [];
  const deleted: string[] = [];
  const overwritten: string[] = [];
  const fileChanges: FileChange[] = [];
  const snapshot = (): ApplyPatchResult => ({
    affected: {
      added: [...added], modified: [...modified],
      deleted: [...deleted], overwritten: [...overwritten],
    },
    summary: formatSummary({ added, modified, deleted, overwritten }),
    fileChanges: [...fileChanges],
  });
  const checkAbort = () => {
    if (signal?.aborted) throw new Error("Operation aborted");
  };

  try {
    checkAbort();
    if (hunks.length === 0) throw new Error("No files were modified.");
    // Validate the entire patch before making any changes, including moves.
    for (const hunk of hunks) {
      validateRelativePath(hunk.path);
      if (hunk.type === "update" && hunk.movePath !== undefined) {
        validateRelativePath(hunk.movePath);
      }
    }
    for (const hunk of hunks) {
      checkAbort();
      const abs = resolve(cwd, hunk.path);
      const dest = hunk.type === "update" && hunk.movePath !== undefined
        ? resolve(cwd, hunk.movePath) : undefined;
      await withMutationPaths(dest ? [abs, dest] : [abs], async (keys) => {
        checkAbort();
        if (dest && keys.length === 1) {
          throw new Error(`Move to: '${hunk.type === "update" ? hunk.movePath : ""}' is the same as the source path '${hunk.path}'. Use Update File without a Move to instead.`);
        }
        if (hunk.type === "add") {
          const exists = await pathExists(abs);
          checkAbort();
          const before = exists ? await readFileText(abs) : "";
          checkAbort();
          await writeFileWithDirs(abs, hunk.contents, checkAbort);
          if (exists) overwritten.push(hunk.path);
          added.push(hunk.path);
          fileChanges.push({ path: hunk.path, before, after: hunk.contents });
        } else if (hunk.type === "delete") {
          await ensureNotDirectory(abs);
          checkAbort();
          const before = await readFileText(abs);
          checkAbort();
          await rm(abs, { force: false });
          deleted.push(hunk.path);
          fileChanges.push({ path: hunk.path, before, after: "" });
        } else {
          const original = await readFileText(abs);
          checkAbort();
          const next = deriveNewContents(original, hunk.chunks, abs);
          if (dest && hunk.movePath !== undefined) {
            const destExists = await pathExists(dest);
            checkAbort();
            const destBefore = destExists ? await readFileText(dest) : "";
            checkAbort();
            await writeFileWithDirs(dest, next, checkAbort);
            if (destExists) {
              overwritten.push(hunk.movePath);
            }
            modified.push(hunk.movePath);
            fileChanges.push({
              path: hunk.movePath,
              before: destBefore,
              after: next,
            });
            // Record the destination even if cancellation or source removal fails.
            checkAbort();
            await ensureNotDirectory(abs);
            checkAbort();
            await rm(abs, { force: false });
            deleted.push(hunk.path);
            fileChanges.push({ path: hunk.path, before: original, after: "" });
          } else {
            await writeFileWithDirs(abs, next, checkAbort);
            modified.push(hunk.path);
            fileChanges.push({
              path: hunk.path,
              before: original,
              after: next,
            });
          }
        }
        // Never release a queue while filesystem work is still in flight.
        // Completed mutations must be recorded before observing cancellation.
        checkAbort();
      });
      onProgress?.(snapshot());
    }
    checkAbort();
    return snapshot();
  } catch (error) {
    const partial = snapshot();
    const message = error instanceof Error ? error.message : String(error);
    const paths = [...new Set(fileChanges.map((change) => change.path))];
    throw new ApplyPatchError(message + (paths.length
      ? `\nFiles already modified before this error: ${paths.join(", ")}. The patch was partially applied; re-read those files before retrying.`
      : ""), partial);
  }
}

function validateRelativePath(path: string): void {
  if (!path.trim() || isAbsolute(path) || win32.isAbsolute(path)) {
    throw new Error(`File path must be relative to the working directory: '${path}'`);
  }
}

async function withMutationPaths<T>(paths: string[], fn: (keys: string[]) => Promise<T>): Promise<T> {
  // Pi queues one canonical path at a time. Deduplicate aliases and acquire
  // canonical keys in sorted order so opposite moves cannot deadlock.
  const keys = [...new Set(await Promise.all(paths.map(async (path) => {
    try { return await realpath(path); }
    catch (error) {
      const code = (error as NodeJS.ErrnoException).code;
      if (code === "ENOENT" || code === "ENOTDIR") return resolve(path);
      throw error;
    }
  })))].sort();
  const lock = (index: number): Promise<T> => index === keys.length
    ? fn(keys)
    : withFileMutationQueue(keys[index]!, () => lock(index + 1));
  return lock(0);
}

async function writeFileWithDirs(
  absPath: string,
  content: string,
  checkAbort: () => void,
): Promise<void> {
  checkAbort();
  try {
    await writeFile(absPath, content, "utf8");
  } catch (error) {
    checkAbort();
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      await mkdir(dirname(absPath), { recursive: true });
      checkAbort();
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

/** True if `absPath` exists (file or directory). */
async function pathExists(absPath: string): Promise<boolean> {
  try {
    await stat(absPath);
    return true;
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") return false;
    throw error;
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
