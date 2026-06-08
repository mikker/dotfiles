import { spawn, spawnSync } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const MAX_BUFFER = 100 * 1024 * 1024;

type RunResult = {
  status: number | null;
  stdout: string;
  stderr: string;
};

function run(command: string, args: string[], cwd: string) {
  return spawnSync(command, args, {
    cwd,
    encoding: "utf8",
    maxBuffer: MAX_BUFFER,
  });
}

function runAsync(command: string, args: string[], cwd: string): Promise<RunResult> {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { cwd, stdio: ["ignore", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";

    child.stdout.setEncoding("utf8");
    child.stderr.setEncoding("utf8");
    child.stdout.on("data", (chunk) => {
      stdout = (stdout + chunk).slice(-MAX_BUFFER);
    });
    child.stderr.on("data", (chunk) => {
      stderr = (stderr + chunk).slice(-MAX_BUFFER);
    });
    child.on("error", reject);
    child.on("close", (status) => resolve({ status, stdout, stderr }));
  });
}

function git(cwd: string, args: string[]) {
  const result = run("git", args, cwd);
  return result.status === 0 ? result.stdout.trim() : "";
}

function gitRoot(cwd: string) {
  return git(cwd, ["rev-parse", "--show-toplevel"]);
}

function buildPrompt(cwd: string, brief: string) {
  const status = git(cwd, ["status", "--short"]);
  const unstagedStat = git(cwd, ["diff", "--stat"]);
  const stagedStat = git(cwd, ["diff", "--cached", "--stat"]);

  return [
    "You are a clean-context review subagent spawned by a parent Pi session.",
    "Review the current repository changes independently.",
    "",
    "Scope:",
    "- Default to reviewing uncommitted and staged changes.",
    "- If the brief asks for another comparison/base, follow the brief and choose appropriate git commands.",
    "- Inspect the full diff yourself; the summary below is only orientation.",
    "- Do not edit files, commit, or perform destructive actions.",
    "- Do not browse web or use external services unless the brief explicitly asks.",
    "- Report only real issues. It is acceptable to find none.",
    "",
    "Brief:",
    brief.trim() || "Review current diff for bugs, regressions, security issues, and maintainability problems.",
    "",
    "Git status --short:",
    status || "(clean or unavailable)",
    "",
    "Unstaged diff --stat:",
    unstagedStat || "(none)",
    "",
    "Staged diff --cached --stat:",
    stagedStat || "(none)",
    "",
    "Return concise structured markdown:",
    "",
    "## Review result",
    "Verdict: approve | changes requested | needs investigation",
    "",
    "## Findings",
    "- [severity] file:line — issue",
    "  Why:",
    "  Fix:",
    "",
    "## Notes",
    "...",
    "",
    "## What I checked",
    "...",
    "",
    "If no issues are found, use:",
    "Verdict: approve",
    "",
    "No issues found.",
    "",
    "Checked: ...",
  ].join("\n");
}

function reviewWithPi(cwd: string, prompt: string, showInternalOutput: boolean) {
  return runAsync(
    "pi",
    [
      "-p",
      "--no-session",
      "--thinking",
      "medium",
      "--tools",
      "read,grep,find,ls,bash",
      ...(showInternalOutput ? ["--verbose"] : []),
      prompt,
    ],
    cwd,
  );
}

export default function reviewAgentExtension(pi: ExtensionAPI) {
  let running = false;
  let showInternalOutput = false;

  pi.registerCommand("review-agent-output", {
    description: "Toggle raw review subagent output in review-agent results",
    getArgumentCompletions(prefix) {
      const items = ["on", "off", "toggle", "status"].map((value) => ({ value, label: value }));
      const filtered = items.filter((item) => item.value.startsWith(prefix));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      const action = args.trim().toLowerCase() || "toggle";
      if (!["on", "off", "toggle", "status"].includes(action)) {
        ctx.ui.notify("Usage: /review-agent-output [on|off|toggle|status]", "error");
        return;
      }
      if (action === "on") showInternalOutput = true;
      if (action === "off") showInternalOutput = false;
      if (action === "toggle") showInternalOutput = !showInternalOutput;
      ctx.ui.notify(`Review agent internal output ${showInternalOutput ? "on" : "off"}.`, "info");
    },
  });

  pi.registerCommand("review-agent", {
    description: "Spawn a clean-context Pi review subagent for the current diff",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();

      const cwd = gitRoot(ctx.cwd);
      if (!cwd) {
        ctx.ui.notify("Not in a git repository", "error");
        return;
      }

      if (running) {
        ctx.ui.notify("Review agent already running", "warning");
        return;
      }

      running = true;
      const frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
      let frame = 0;
      const started = Date.now();
      const timer = setInterval(() => {
        const seconds = Math.floor((Date.now() - started) / 1000);
        ctx.ui.setStatus("review-agent", `${frames[frame++ % frames.length]} reviewing ${seconds}s`);
      }, 120);

      ctx.ui.notify("Review agent running…", "info");
      try {
        const result = await reviewWithPi(cwd, buildPrompt(cwd, args || ""), showInternalOutput);
        const output = (result.stdout || result.stderr || "").trim();
        const internalOutput = result.stderr
          ? `## Review agent internal output\n\n\`\`\`\n${result.stderr.trim()}\n\`\`\``
          : "";

        if (result.status !== 0) {
          ctx.ui.notify("Review agent failed", "error");
          pi.sendMessage({
            customType: "review-agent-result",
            content: `## Review agent failed\n\n${output || `pi exited with status ${result.status}`}${showInternalOutput && internalOutput ? `\n\n---\n\n${internalOutput}` : ""}`,
            display: true,
            details: { status: result.status },
          });
          return;
        }

        pi.sendMessage({
          customType: "review-agent-result",
          content: `${output || "Review agent returned no output."}${showInternalOutput && internalOutput ? `\n\n---\n\n${internalOutput}` : ""}`,
          display: true,
          details: { cwd, brief: args || "", showInternalOutput },
        });
        ctx.ui.notify("Review agent finished", "success");
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify("Review agent failed", "error");
        pi.sendMessage({
          customType: "review-agent-result",
          content: `## Review agent failed\n\n${message}`,
          display: true,
          details: { error: message },
        });
      } finally {
        clearInterval(timer);
        ctx.ui.setStatus("review-agent", undefined);
        running = false;
      }
    },
  });
}
