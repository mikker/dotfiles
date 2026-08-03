// Dotfiles-managed Pi extension.

/**
 * Parser for the V4A `apply_patch` patch format.
 *
 * Ported from openai/codex `codex-rs/apply-patch/src/streaming_parser.rs` and
 * `parser.rs`. This is a single-pass line state machine that produces the
 * same `Hunk` structure the Codex parser emits, including the lenient cases
 * (CRLF, whitespace-padded markers, bare empty update lines, `*** End of
 * File`, heredoc wrappers, and update hunks without an explicit `@@` header).
 */

import type { Hunk, ParseError, ParseResult, UpdateFileChunk } from "./types";

const BEGIN_PATCH_MARKER = "*** Begin Patch";
const END_PATCH_MARKER = "*** End Patch";
const ADD_FILE_MARKER = "*** Add File: ";
const DELETE_FILE_MARKER = "*** Delete File: ";
const UPDATE_FILE_MARKER = "*** Update File: ";
const MOVE_TO_MARKER = "*** Move to: ";
const EOF_MARKER = "*** End of File";
const CHANGE_CONTEXT_MARKER = "@@ ";
const EMPTY_CHANGE_CONTEXT_MARKER = "@@";
const ENVIRONMENT_ID_MARKER = "*** Environment ID:";

type Mode =
  | "NotStarted"
  | "StartedPatch"
  | "AddFile"
  | "DeleteFile"
  | "UpdateFile"
  | "EndedPatch";

export class ApplyPatchParseError extends Error {
  readonly parseError: ParseError;
  constructor(parseError: ParseError) {
    super(parseError.message);
    this.name = "ApplyPatchParseError";
    this.parseError = parseError;
  }
}

function fail(message: string, lineNumber: number | null): never {
  throw new ApplyPatchParseError({ message, lineNumber });
}

/** Split patch text into lines, stripping a single trailing `\r` per line. */
function toLines(patch: string): string[] {
  return patch
    .trim()
    .split("\n")
    .map((line) => (line.endsWith("\r") ? line.slice(0, -1) : line));
}

/** Strip a `<<EOF ... EOF` heredoc wrapper if the strict boundaries fail. */
function stripHeredoc(lines: string[]): string[] {
  if (lines.length === 0) return lines;
  const firstOk = (lines[0] ?? "").trim() === BEGIN_PATCH_MARKER;
  const lastOk = (lines[lines.length - 1] ?? "").trim() === END_PATCH_MARKER;
  if (firstOk && lastOk) return lines;
  if (lines.length >= 4) {
    const f = lines[0] ?? "";
    if (f === "<<EOF" || f === "<<'EOF'" || f === '<<"EOF"') {
      if ((lines[lines.length - 1] ?? "").endsWith("EOF")) {
        return lines.slice(1, lines.length - 1);
      }
    }
  }
  return lines;
}

export function parsePatch(patch: string): ParseResult {
  const lines = stripHeredoc(toLines(patch));

  let mode: Mode = "NotStarted";
  const hunks: Hunk[] = [];
  let environmentId: string | null = null;
  let updateHunkLineNumber = 0;

  const ensureUpdateHunkNotEmpty = (line: string, lineNumber: number): void => {
    const last = hunks[hunks.length - 1];
    if (last?.type !== "update") return;
    if (last.chunks.length === 0 && mode === "UpdateFile") {
      fail(
        `Update file hunk for path '${last.path}' is empty`,
        updateHunkLineNumber,
      );
    }
    const lc = last.chunks[last.chunks.length - 1];
    if (lc && lc.oldLines.length === 0 && lc.newLines.length === 0) {
      if (line === END_PATCH_MARKER) {
        fail("Update hunk does not contain any lines", lineNumber);
      }
      fail(
        `Unexpected line found in update hunk: '${line}'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)`,
        lineNumber,
      );
    }
  };

  const handleHunkHeadersAndEndPatch = (
    line: string,
    raw: string,
    lineNumber: number,
  ): boolean => {
    if (mode === "StartedPatch" && line.startsWith(ENVIRONMENT_ID_MARKER)) {
      const value = line.slice(ENVIRONMENT_ID_MARKER.length).trim();
      if (environmentId !== null) {
        fail(
          "apply_patch environment_id cannot be specified more than once",
          lineNumber,
        );
      }
      if (value === "") {
        fail("apply_patch environment_id cannot be empty", lineNumber);
      }
      environmentId = value;
      return true;
    }
    if (line === END_PATCH_MARKER) {
      ensureUpdateHunkNotEmpty(line, lineNumber);
      mode = "EndedPatch";
      return true;
    }
    if (line.startsWith(ADD_FILE_MARKER)) {
      ensureUpdateHunkNotEmpty(line, lineNumber);
      hunks.push({
        type: "add",
        path: line.slice(ADD_FILE_MARKER.length),
        contents: "",
      });
      mode = "AddFile";
      return true;
    }
    if (line.startsWith(DELETE_FILE_MARKER)) {
      ensureUpdateHunkNotEmpty(line, lineNumber);
      hunks.push({
        type: "delete",
        path: line.slice(DELETE_FILE_MARKER.length),
      });
      mode = "DeleteFile";
      return true;
    }
    if (line.startsWith(UPDATE_FILE_MARKER)) {
      ensureUpdateHunkNotEmpty(line, lineNumber);
      hunks.push({
        type: "update",
        path: line.slice(UPDATE_FILE_MARKER.length),
        movePath: undefined,
        chunks: [],
      });
      mode = "UpdateFile";
      updateHunkLineNumber = lineNumber;
      return true;
    }
    // `raw` is referenced for nothing here, but kept in the signature for
    // parity with the caller; avoid an unused-var lint.
    void raw;
    return false;
  };

  const ensureChunk = (lineNumber: number): UpdateFileChunk => {
    const last = hunks[hunks.length - 1];
    if (last?.type !== "update") {
      fail("Internal error: update chunk without an update hunk", lineNumber);
    }
    if (last.chunks.length === 0) {
      const chunk: UpdateFileChunk = {
        changeContext: null,
        oldLines: [],
        newLines: [],
        isEndOfFile: false,
      };
      last.chunks.push(chunk);
    }
    const chunk = last.chunks[last.chunks.length - 1];
    if (!chunk) fail("Internal error: update chunk missing", lineNumber);
    return chunk;
  };

  const handleUpdateContent = (
    raw: string,
    updateLine: string,
    lineNumber: number,
  ): void => {
    const last = hunks[hunks.length - 1];
    if (last?.type !== "update") {
      fail("Internal error: update content without an update hunk", lineNumber);
    }
    const lc = last.chunks[last.chunks.length - 1];

    // After an *** End of File marker, only a new @@ hunk or blank lines
    // are allowed.
    if (lc?.isEndOfFile) {
      if (updateLine === "") return;
      if (
        updateLine !== EMPTY_CHANGE_CONTEXT_MARKER &&
        !updateLine.startsWith(CHANGE_CONTEXT_MARKER)
      ) {
        fail(
          `Expected update hunk to start with a @@ context marker, got: '${raw}'`,
          lineNumber,
        );
      }
    }

    // *** Move to: <path> -- only valid before any chunk.
    if (last.chunks.length === 0 && last.movePath === undefined) {
      if (updateLine.startsWith(MOVE_TO_MARKER)) {
        last.movePath = updateLine.slice(MOVE_TO_MARKER.length);
        return;
      }
    }

    // A @@ marker while the current chunk is still empty is an error.
    if (
      (updateLine === EMPTY_CHANGE_CONTEXT_MARKER ||
        updateLine.startsWith(CHANGE_CONTEXT_MARKER)) &&
      lc &&
      lc.oldLines.length === 0 &&
      lc.newLines.length === 0
    ) {
      fail(
        `Unexpected line found in update hunk: '${raw}'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)`,
        lineNumber,
      );
    }

    if (updateLine === EMPTY_CHANGE_CONTEXT_MARKER) {
      last.chunks.push({
        changeContext: null,
        oldLines: [],
        newLines: [],
        isEndOfFile: false,
      });
      return;
    }
    if (updateLine.startsWith(CHANGE_CONTEXT_MARKER)) {
      last.chunks.push({
        changeContext: updateLine.slice(CHANGE_CONTEXT_MARKER.length),
        oldLines: [],
        newLines: [],
        isEndOfFile: false,
      });
      return;
    }
    if (updateLine === EOF_MARKER) {
      if (lc && lc.oldLines.length === 0 && lc.newLines.length === 0) {
        fail("Update hunk does not contain any lines", lineNumber);
      }
      if (lc) lc.isEndOfFile = true;
      return;
    }
    if (raw === "") {
      const chunk = ensureChunk(lineNumber);
      chunk.oldLines.push("");
      chunk.newLines.push("");
      return;
    }
    if (raw.startsWith(" ")) {
      const chunk = ensureChunk(lineNumber);
      const s = raw.slice(1);
      chunk.oldLines.push(s);
      chunk.newLines.push(s);
      return;
    }
    if (raw.startsWith("+")) {
      const chunk = ensureChunk(lineNumber);
      chunk.newLines.push(raw.slice(1));
      return;
    }
    if (raw.startsWith("-")) {
      const chunk = ensureChunk(lineNumber);
      chunk.oldLines.push(raw.slice(1));
      return;
    }
    if (lc && (lc.oldLines.length > 0 || lc.newLines.length > 0)) {
      fail(
        `Expected update hunk to start with a @@ context marker, got: '${raw}'`,
        lineNumber,
      );
    }
    fail(
      `Unexpected line found in update hunk: '${raw}'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)`,
      lineNumber,
    );
  };

  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i] ?? "";
    const lineNumber = i + 1;
    const trimmed = raw.trim();
    const updateLine = raw.replace(/\s+$/u, "");
    // Switch on the full `Mode` union. `mode` is mutated by the closures
    // below, which TypeScript's control-flow analysis does not track, so cast
    // to the declared union to keep every case reachable.

    switch (mode as Mode) {
      case "NotStarted":
        if (trimmed === BEGIN_PATCH_MARKER) {
          mode = "StartedPatch";
        } else {
          fail(
            "The first line of the patch must be '*** Begin Patch'",
            lineNumber,
          );
        }
        break;

      case "StartedPatch":
        if (handleHunkHeadersAndEndPatch(trimmed, raw, lineNumber)) break;
        fail(
          `'${trimmed}' is not a valid hunk header. Valid hunk headers: '*** Add File: {path}', '*** Delete File: {path}', '*** Update File: {path}'`,
          lineNumber,
        );
        break;

      case "AddFile":
        if (handleHunkHeadersAndEndPatch(trimmed, raw, lineNumber)) break;
        if (raw.startsWith("+")) {
          const add = hunks[hunks.length - 1];
          if (add && add.type === "add") {
            add.contents += `${raw.slice(1)}\n`;
          }
          break;
        }
        fail(
          `'${trimmed}' is not a valid hunk header. Valid hunk headers: '*** Add File: {path}', '*** Delete File: {path}', '*** Update File: {path}'`,
          lineNumber,
        );
        break;

      case "DeleteFile":
        if (handleHunkHeadersAndEndPatch(trimmed, raw, lineNumber)) break;
        fail(
          `'${trimmed}' is not a valid hunk header. Valid hunk headers: '*** Add File: {path}', '*** Delete File: {path}', '*** Update File: {path}'`,
          lineNumber,
        );
        break;

      case "UpdateFile":
        if (handleHunkHeadersAndEndPatch(updateLine, raw, lineNumber)) break;
        handleUpdateContent(raw, updateLine, lineNumber);
        break;

      case "EndedPatch":
        if (trimmed !== "") {
          fail(
            "The last line of the patch must be '*** End Patch'",
            lineNumber,
          );
        }
        break;
    }
  }

  if ((mode as Mode) !== "EndedPatch") {
    fail("The last line of the patch must be '*** End Patch'", null);
  }

  return { hunks, environmentId };
}
