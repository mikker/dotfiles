// Dotfiles-managed Pi extension.

/**
 * Types for the V4A `apply_patch` format (Codex / GPT-style models).
 *
 * The grammar is a stripped-down, file-oriented diff format:
 *
 *   *** Begin Patch
 *   [ one or more file sections ]
 *   *** End Patch
 *
 * Ported from openai/codex `codex-rs/apply-patch` (parser.rs / streaming_parser.rs).
 */

import Type, { type Static } from "typebox";

export const APPLY_PATCH_SCHEMA = Type.Object({
  input: Type.String({
    description:
      "The entire V4A patch text (*** Begin Patch ... *** End Patch).",
  }),
});
export type ApplyPatchToolParams = Static<typeof APPLY_PATCH_SCHEMA>;

export type Hunk =
  | { type: "add"; path: string; contents: string }
  | { type: "delete"; path: string }
  | {
      type: "update";
      path: string;
      movePath?: string;
      chunks: UpdateFileChunk[];
    };

export interface UpdateFileChunk {
  /** Optional single-line context (class/function) used to locate the chunk. */
  changeContext: string | null;
  /** Contiguous block of lines to replace; must occur after changeContext. */
  oldLines: string[];
  newLines: string[];
  /** When true, oldLines must occur at the end of the source file. */
  isEndOfFile: boolean;
}

export interface ParseError {
  message: string;
  /** 1-based line number, or null for whole-patch errors. */
  lineNumber: number | null;
}

export interface ParseResult {
  hunks: Hunk[];
  environmentId: string | null;
}

export interface AffectedPaths {
  added: string[];
  modified: string[];
  deleted: string[];
  /**
   * Paths that existed before the patch and were overwritten by an
   * `*** Add File` or `*** Move to`. Surfaced as a footgun signal so a silent
   * clobber does not go unnoticed (codex records `overwritten_content` for
   * the same reason). Empty when every Add/Move created a genuinely new path.
   */
  overwritten: string[];
}

export interface ApplyPatchResult {
  affected: AffectedPaths;
  /** Git-style summary lines, e.g. "A path", "M path", "D path". */
  summary: string[];
  /** Per-file before/after contents for result diff rendering. */
  fileChanges: FileChange[];
}

export interface FileChange {
  path: string;
  before: string;
  after: string;
}
