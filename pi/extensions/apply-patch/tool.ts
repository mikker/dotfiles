// Dotfiles-managed Pi extension.

/**
 * `apply_patch` tool definition for Codex / GPT-style models.
 *
 * GPT coding models were post-trained on a freeform text-patch interface (the
 * V4A format) rather than JSON `old_string/new_string` tools. This tool takes a
 * single `input` string containing a raw V4A patch, parses it, and applies it.
 *
 * Adapted from openai/codex `codex-rs/tools/src/apply_patch_tool.rs`
 * (`APPLY_PATCH_JSON_TOOL_DESCRIPTION`) and the `tool_apply_patch.lark`
 * grammar.
 */

import {
  generateDiffString,
  type ToolDefinition,
} from "@earendil-works/pi-coding-agent";

import { applyHunks } from "./apply";
import { ApplyPatchParseError, parsePatch } from "./parser";
import {
  type ApplyPatchRenderState,
  renderApplyPatchCall,
  renderApplyPatchResult,
} from "./render";
import { APPLY_PATCH_SCHEMA, type ApplyPatchResult } from "./types";

const APPLY_PATCH_DESCRIPTION = `Apply a file patch in the V4A format. Use this tool to create, update, delete, or rename files. The entire patch is passed as a single raw text string in the \`input\` field -- do NOT wrap it in JSON, do NOT use line numbers.

The patch is an envelope of file operations:

*** Begin Patch
[ one or more file sections ]
*** End Patch

Each section starts with one of:
*** Add File: <path>        -- create a file; every following line is a \`+\` line (the initial contents)
*** Delete File: <path>     -- remove an existing file; nothing follows
*** Update File: <path>     -- patch an existing file in place (optionally with a rename)

An Update File section may be immediately followed by *** Move to: <new path> to rename the file.
Then one or more hunks, each introduced by @@ (optionally followed by a hunk header that names the enclosing class or function).
Within a hunk, every line starts with one of:
  \` \` (space) -- context line (unchanged, used to locate the change)
  \`-\`         -- removed line
  \`+\`         -- added line
*** End of File marks that the preceding change must occur at the end of the file.

Context rules:
- Show 3 lines of code immediately above and below each change. If a change is within 3 lines of a previous change, do NOT duplicate the previous change's trailing context as the next change's leading context.
- If 3 lines of context cannot uniquely identify the snippet, use the @@ operator to name the enclosing class or function, e.g.:
  @@ class BaseClass
  [3 lines of pre-context]
  - [old_code]
  + [new_code]
  [3 lines of post-context]
- If a block repeats many times, stack multiple @@ statements to jump to the right context.

Hunk contiguity rules:
- Each hunk must match one contiguous block of lines from the file. Do not end a hunk in the middle of an expression, object literal, function body, or statement.
- When a change spans an entire block (for example, renaming a function call and the object literal passed to it), include the whole block in a single hunk rather than splitting it across hunks.
- When using Update File with Move to, prefer a single hunk for that file. If multiple hunks are required, each hunk must resume immediately after the previous hunk's last matched line; do not skip over unchanged lines between hunks.

Grammar:
Patch       := Begin { FileOp } End
Begin       := "*** Begin Patch" NEWLINE
End         := "*** End Patch" NEWLINE
FileOp      := AddFile | DeleteFile | UpdateFile
AddFile     := "*** Add File: " path NEWLINE { "+" line NEWLINE }
DeleteFile  := "*** Delete File: " path NEWLINE
UpdateFile  := "*** Update File: " path NEWLINE [ MoveTo ] { Hunk }
MoveTo      := "*** Move to: " newPath NEWLINE
Hunk        := "@@" [ header ] NEWLINE { HunkLine } [ "*** End of File" NEWLINE ]
HunkLine    := (" " | "-" | "+") text NEWLINE

Rules:
- You must include a header with your intended action (Add/Delete/Update).
- Prefix new lines with \`+\` even when creating a new file.
- File references must be relative to the working directory, NEVER absolute.
- A single patch may combine several operations across multiple files.`;

const APPLY_PATCH_GUIDELINES = [
  "apply_patch: Use for any file edit, creation, deletion, or rename on GPT/Codex models. It is the in-distribution editing interface for this model family.",
  "apply_patch: Pass the whole patch as a single raw text string in `input`. Do not wrap it in JSON and do not use line numbers.",
  "apply_patch: Show 3 lines of context around each change and use @@ with the enclosing class/function name when context alone cannot uniquely locate the change.",
  "apply_patch: Each hunk must be one contiguous block of lines from the file. Do not split an expression, object literal, or block across hunks; include the whole construct in one hunk.",
  "apply_patch: Do not re-read files after calling apply_patch. The tool result will report success or failure, and on failure it will include any partial changes that were already applied.",
];

export interface ApplyPatchDetails {
  /** The original patch text that was applied. */
  patch: string;
  /** Git-style summary lines, e.g. "A path", "M path", "D path". */
  summary: string[];
  /** Per-file display diffs. */
  fileDiffs?: ApplyPatchFileDiff[];
  /** Display-oriented diff of the changes made. */
  diff: string;
}

export interface ApplyPatchFileDiff {
  status: "A" | "M" | "D";
  path: string;
  diff: string;
}

export function createApplyPatchToolDefinition(
  cwd: string,
): ToolDefinition<
  typeof APPLY_PATCH_SCHEMA,
  ApplyPatchDetails | undefined,
  ApplyPatchRenderState
> {
  return {
    name: "apply_patch",
    label: "apply_patch",
    description: APPLY_PATCH_DESCRIPTION,
    promptSnippet:
      "Apply a V4A text patch to create, update, delete, or rename files",
    promptGuidelines: APPLY_PATCH_GUIDELINES,
    parameters: APPLY_PATCH_SCHEMA,
    renderShell: "default",
    async execute(_toolCallId, params, _signal, onUpdate, ctx) {
      const workdir = ctx?.cwd ?? cwd;
      const { hunks } = parsePatch(params.input);
      // Stream a partial result per committed hunk so the UI renders files as
      // they are edited/created, instead of only after the whole patch lands.
      const result = await applyHunks(hunks, workdir, (partial) => {
        onUpdate?.({
          content: [],
          details: buildApplyPatchDetails(params.input, partial),
        });
      });
      const details = buildApplyPatchDetails(params.input, result);
      return {
        content: [
          {
            type: "text",
            text:
              "Success. Updated the following files:\n" +
              result.summary.join("\n"),
          },
        ],
        details,
      };
    },
    renderCall: renderApplyPatchCall,
    renderResult: renderApplyPatchResult,
  };
}

function getFileChangeStatus(
  before: string,
  after: string,
): ApplyPatchFileDiff["status"] {
  if (!before) return "A";
  if (!after) return "D";
  return "M";
}

/**
 * Build the renderable `ApplyPatchDetails` (summary + per-file diffs) from a
 * (possibly partial) apply result. Shared by the final return and the
 * per-hunk `onUpdate` stream so the live view matches the settled view.
 */
function buildApplyPatchDetails(
  patch: string,
  result: ApplyPatchResult,
): ApplyPatchDetails {
  const fileDiffs = result.fileChanges
    .map((change): ApplyPatchFileDiff | undefined => {
      const diff = generateDiffString(change.before, change.after).diff;
      if (!diff) return undefined;
      return {
        status: getFileChangeStatus(change.before, change.after),
        path: change.path,
        diff,
      };
    })
    .filter((change): change is ApplyPatchFileDiff => change !== undefined);
  const diff = fileDiffs
    .map((change) => `${change.path}\n${change.diff}`)
    .join("\n\n");
  return {
    patch,
    summary: result.summary,
    fileDiffs,
    diff,
  };
}

// Re-export parse error type so callers (and tests) can distinguish parse
// failures from apply failures.
export { ApplyPatchParseError };
