import { spawn, type ChildProcess } from "node:child_process";
import { existsSync } from "node:fs";
import { writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { basename, join } from "node:path";
import {
  BorderedLoader,
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
  type ExtensionAPI,
  truncateTail,
} from "@earendil-works/pi-coding-agent";

const CAPTURE_LIMIT = 2 * 1024 * 1024;

type RunResult = {
  status: number | null;
  stdout: string;
  stderr: string;
};

function getPiInvocation(args: string[]) {
  const currentScript = process.argv[1];
  const isBunVirtualScript = currentScript?.startsWith("/$bunfs/root/");
  if (currentScript && !isBunVirtualScript && existsSync(currentScript)) {
    return { command: process.execPath, args: [currentScript, ...args] };
  }

  const execName = basename(process.execPath).toLowerCase();
  return /^(node|bun)(\.exe)?$/.test(execName)
    ? { command: "pi", args }
    : { command: process.execPath, args };
}

function appendCapped(current: string, chunk: Buffer | string): string {
  const next = current + chunk.toString();
  return next.length <= CAPTURE_LIMIT ? next : next.slice(-CAPTURE_LIMIT);
}

function runPi(
  args: string[],
  cwd: string,
  signal: AbortSignal,
  onChild: (child: ChildProcess | null) => void,
): Promise<RunResult> {
  return new Promise((resolve, reject) => {
    const invocation = getPiInvocation(args);
    const child = spawn(invocation.command, invocation.args, {
      cwd,
      shell: false,
      stdio: ["ignore", "pipe", "pipe"],
    });
    onChild(child);

    let stdout = "";
    let stderr = "";
    child.stdout?.on("data", (chunk) => (stdout = appendCapped(stdout, chunk)));
    child.stderr?.on("data", (chunk) => (stderr = appendCapped(stderr, chunk)));

    const abort = () => child.kill("SIGTERM");
    if (signal.aborted) abort();
    else signal.addEventListener("abort", abort, { once: true });

    child.on("error", reject);
    child.on("close", (status) => {
      signal.removeEventListener("abort", abort);
      onChild(null);
      resolve({ status, stdout, stderr });
    });
  });
}

async function git(pi: ExtensionAPI, cwd: string, args: string[]) {
  const result = await pi.exec("git", ["-C", cwd, ...args], { timeout: 5_000 });
  return result.code === 0 ? result.stdout.trim() : "";
}

async function gitRoot(pi: ExtensionAPI, cwd: string) {
  return git(pi, cwd, ["rev-parse", "--show-toplevel"]);
}

async function buildPrompt(pi: ExtensionAPI, cwd: string, brief: string) {
  const [status, unstagedStat, stagedStat] = await Promise.all([
    git(pi, cwd, ["status", "--short"]),
    git(pi, cwd, ["diff", "--stat"]),
    git(pi, cwd, ["diff", "--cached", "--stat"]),
  ]);

  return [
    "You are a clean-context review subagent spawned by a parent Pi session.",
    "Review the current repository changes independently.",
    "",
    "Scope:",
    "- Default to reviewing uncommitted and staged changes.",
    "- If the brief asks for another comparison/base, follow it.",
    "- Inspect the full diff yourself; this summary is orientation only.",
    "- Do not edit, commit, or perform destructive actions.",
    "- Report only real issues. It is acceptable to find none.",
    "",
    `Brief:\n${brief.trim() || "Review for bugs, regressions, security issues, and maintainability problems."}`,
    "",
    `Git status --short:\n${status || "(clean or unavailable)"}`,
    "",
    `Unstaged diff --stat:\n${unstagedStat || "(none)"}`,
    "",
    `Staged diff --cached --stat:\n${stagedStat || "(none)"}`,
    "",
    "Return concise structured markdown:",
    "## Review result",
    "Verdict: approve | changes requested | needs investigation",
    "",
    "## Findings",
    "- [severity] file:line — issue",
    "  Why:",
    "  Fix:",
    "",
    "## What I checked",
    "...",
  ].join("\n");
}

async function formatOutput(output: string): Promise<string> {
  const truncation = truncateTail(output, {
    maxBytes: DEFAULT_MAX_BYTES,
    maxLines: DEFAULT_MAX_LINES,
  });
  if (!truncation.truncated) return truncation.content;

  const file = join(tmpdir(), `pi-review-agent-${Date.now()}.md`);
  await writeFile(file, output, "utf8");
  return `${truncation.content}\n\n[Output truncated. Full review: ${file}]`;
}

export default function reviewAgentExtension(pi: ExtensionAPI) {
  let showInternalOutput = false;
  let child: ChildProcess | null = null;
  let controller: AbortController | null = null;

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
      if (controller) {
        ctx.ui.notify("Review agent already running", "warning");
        return;
      }

      const cwd = await gitRoot(pi, ctx.cwd);
      if (!cwd) {
        ctx.ui.notify("Not in a git repository", "error");
        return;
      }

      const prompt = await buildPrompt(pi, cwd, args);
      const commandArgs = [
        "-p",
        "--no-session",
        "--thinking",
        "medium",
        "--tools",
        "read,grep,find,ls,bash",
        ...(showInternalOutput ? ["--verbose"] : []),
        prompt,
      ];

      controller = new AbortController();
      const run = (signal: AbortSignal) =>
        runPi(commandArgs, cwd, signal, (value) => (child = value));

      try {
        const result =
          ctx.mode === "tui"
            ? await ctx.ui.custom<RunResult | null>((tui, theme, _keybindings, done) => {
                const loader = new BorderedLoader(tui, theme, "Review agent running...");
                loader.onAbort = () => {
                  controller?.abort();
                  done(null);
                };
                void run(controller!.signal).then(done, () => done(null));
                return loader;
              })
            : await run(controller.signal);

        if (!result) {
          ctx.ui.notify("Review agent cancelled", "info");
          return;
        }

        const rawOutput = (result.stdout || result.stderr || "").trim();
        const internalOutput =
          showInternalOutput && result.stderr
            ? `\n\n---\n\n## Review agent internal output\n\n\`\`\`\n${result.stderr.trim()}\n\`\`\``
            : "";
        const output = await formatOutput(rawOutput + internalOutput);

        pi.sendMessage({
          customType: "review-agent-result",
          content:
            result.status === 0
              ? output || "Review agent returned no output."
              : `## Review agent failed\n\n${output || `pi exited with status ${result.status}`}`,
          display: true,
          details: { cwd, brief: args, status: result.status },
        });
        ctx.ui.notify(result.status === 0 ? "Review agent finished" : "Review agent failed", result.status === 0 ? "info" : "error");
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`Review agent failed: ${message}`, "error");
      } finally {
        controller?.abort();
        controller = null;
        child = null;
      }
    },
  });

  pi.on("session_shutdown", async () => {
    controller?.abort();
    child?.kill("SIGTERM");
    controller = null;
    child = null;
  });
}
