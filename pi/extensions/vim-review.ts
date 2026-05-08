import { spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const REVIEW_COMMENT_PATTERN = /^\s*#\$#\s+/;

const PROMPT_PREFIX = [
  "The following is an annotated git diff with review comments/requests.",
  "Reviewer comments are lines beginning with #$#, optionally indented.",
  "Treat #$# lines as feedback to address; do not assume they are part of the patch.",
  "",
].join("\n");

const BUFFER_INSTRUCTIONS = [
  "#$# Add review comments as lines beginning with #$#",
  "#$# :wq submits commented hunks; :cq cancels",
  "",
].join("\n");

function git(cwd: string, args: string[]) {
  return spawnSync("git", args, {
    cwd,
    encoding: "utf8",
    maxBuffer: 100 * 1024 * 1024,
  });
}

function gitOk(cwd: string, args: string[]) {
  return git(cwd, args).status === 0;
}

function mainBranch(cwd: string) {
  for (const branch of ["main", "master"]) {
    if (gitOk(cwd, ["rev-parse", "--verify", `${branch}^{commit}`])) return branch;
    if (gitOk(cwd, ["rev-parse", "--verify", `origin/${branch}^{commit}`])) return `origin/${branch}`;
  }
  return "HEAD";
}

function untrackedDiff(cwd: string) {
  const files = git(cwd, ["ls-files", "--others", "--exclude-standard", "-z"]);
  if (files.status !== 0 || !files.stdout) return "";

  return files.stdout
    .split("\0")
    .filter(Boolean)
    .map((file) => {
      const result = git(cwd, ["diff", "--no-index", "--", "/dev/null", file]);
      const text = result.stdout || result.stderr || "";
      return text
        .replace(/^diff --git \/dev\/null .+$/m, `diff --git a/${file} b/${file}`)
        .replace(/^--- \/dev\/null$/m, `--- a/${file}`)
        .replace(/^\+\+\+ .+$/m, `+++ b/${file}`);
    })
    .join("\n");
}

function buildDiff(cwd: string) {
  const stagedClean = gitOk(cwd, ["diff", "--cached", "--quiet", "--exit-code"]);
  const unstagedClean = gitOk(cwd, ["diff", "--quiet", "--exit-code"]);
  const untracked = untrackedDiff(cwd);
  const workingTreeClean = stagedClean && unstagedClean && !untracked.trim();
  const base = workingTreeClean ? mainBranch(cwd) : "HEAD";
  const diff = git(cwd, ["diff", "--no-ext-diff", "--find-renames", base, "--"]);
  if (diff.status !== 0) throw new Error(diff.stderr || `git diff failed against ${base}`);

  const body = [diff.stdout.trimEnd(), untracked.trimEnd()].filter(Boolean).join("\n\n");
  return { base, body };
}

function isFileHeader(line: string) {
  return line.startsWith("diff --git ");
}

function isHunkHeader(line: string) {
  return line.startsWith("@@ ");
}

function nextIndex(lines: string[], start: number, predicate: (line: string) => boolean) {
  for (let index = start; index < lines.length; index++) {
    if (predicate(lines[index])) return index;
  }
  return lines.length;
}

function splitFileSections(text: string) {
  const lines = text.split("\n");
  const sections: string[][] = [];
  let start = 0;

  while (start < lines.length) {
    const next = nextIndex(lines, start + 1, isFileHeader);
    sections.push(lines.slice(start, next));
    start = next;
  }

  return sections;
}

function hasReviewComment(text: string) {
  return text.split("\n").some((line) => REVIEW_COMMENT_PATTERN.test(line));
}

function stripBufferInstructions(text: string) {
  return text.startsWith(BUFFER_INSTRUCTIONS) ? text.slice(BUFFER_INSTRUCTIONS.length) : text;
}

function stripUncommentedHunks(original: string, annotated: string) {
  annotated = stripBufferInstructions(annotated);

  const originalSections = splitFileSections(original.trimEnd());
  const annotatedSections = splitFileSections(annotated.trimEnd());
  const kept: string[] = [];

  for (let sectionIndex = 0; sectionIndex < originalSections.length; sectionIndex++) {
    const originalLines = originalSections[sectionIndex];
    const annotatedLines = annotatedSections[sectionIndex] ?? [];
    const firstHunk = nextIndex(originalLines, 0, isHunkHeader);
    const originalHeader = originalLines.slice(0, firstHunk).join("\n");
    const annotatedHeaderEnd = nextIndex(annotatedLines, 0, isHunkHeader);
    const annotatedHeader = annotatedLines.slice(0, annotatedHeaderEnd).join("\n");
    const header = annotatedLines.slice(0, annotatedHeaderEnd);
    const hunks: string[] = [];

    if (annotatedHeader && annotatedHeader !== originalHeader) {
      kept.push(annotatedLines.join("\n"));
      continue;
    }

    let hunkStart = firstHunk;
    while (hunkStart < originalLines.length) {
      const hunkEnd = nextIndex(originalLines, hunkStart + 1, isHunkHeader);
      const hunkHeader = originalLines[hunkStart];
      const annotatedStart = annotatedLines.findIndex((line) => line === hunkHeader);

      if (annotatedStart >= 0) {
        const annotatedEnd = nextIndex(
          annotatedLines,
          annotatedStart + 1,
          (line) => isHunkHeader(line) || isFileHeader(line),
        );
        const annotatedHunk = annotatedLines.slice(annotatedStart, annotatedEnd).join("\n");
        if (hasReviewComment(annotatedHunk)) hunks.push(annotatedHunk);
      }

      hunkStart = hunkEnd;
    }

    if (hunks.length > 0) kept.push([...header, ...hunks].join("\n"));
  }

  return kept.join("\n\n").trimEnd();
}

export default function vimReviewExtension(pi: ExtensionAPI) {
  pi.registerCommand("vim-review", {
    description: "Open the current git diff in vim, then place annotated review notes in the prompt",
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();

      const rootResult = git(ctx.cwd, ["rev-parse", "--show-toplevel"]);
      if (rootResult.status !== 0) {
        ctx.ui.notify("Not in a git repository", "error");
        return;
      }

      const cwd = rootResult.stdout.trim();
      let built: { base: string; body: string };
      try {
        built = buildDiff(cwd);
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
        return;
      }

      if (!built.body.trim()) {
        ctx.ui.notify(`No diff against ${built.base}`, "info");
        return;
      }

      const dir = mkdtempSync(join(tmpdir(), "pi-vim-review-"));
      const file = join(dir, "annotated.diff");
      writeFileSync(file, BUFFER_INSTRUCTIONS + built.body + "\n", "utf8");

      ctx.ui.notify(`Opening vim for diff against ${built.base} (:wq submits, :cq cancels)`, "info");
      const vim = spawnSync(
        process.env.VISUAL || process.env.EDITOR || "vim",
        [
          "-c",
          "setlocal filetype=diff number cursorline signcolumn=no nowrap foldmethod=syntax",
          "-c",
          "normal! gg",
          file,
        ],
        {
          cwd,
          stdio: "inherit",
        },
      );

      if (vim.status !== 0) {
        rmSync(dir, { recursive: true, force: true });
        ctx.ui.notify("vim-review cancelled", "info");
        return;
      }

      const annotated = readFileSync(file, "utf8").trimEnd();
      rmSync(dir, { recursive: true, force: true });

      const reviewed = stripUncommentedHunks(built.body, annotated);
      if (!reviewed) {
        ctx.ui.notify("No review comments found; prompt unchanged", "info");
        return;
      }

      ctx.ui.setEditorText(PROMPT_PREFIX + reviewed);
      ctx.ui.notify("Commented diff hunks loaded into prompt. Press Enter to send.", "success");
    },
  });
}
