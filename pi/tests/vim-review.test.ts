import assert from "node:assert/strict";
import { EventEmitter } from "node:events";
import { mock, test } from "node:test";

const diff = [
  "diff --git a/file b/file", "--- a/file", "+++ b/file",
  "@@ -1 +1 @@", "-old", "+new",
  "@@ -3 +3 @@", "-other", "+change",
].join("\n");
let events: string[];
let buffer: string;
let outcome: { code?: number | null; signal?: string; error?: string; throws?: boolean };
let fileError: "read" | "write" | undefined;
let annotate = true;
let invocation: { command: string; args: string[]; options: any };

mock.module("node:child_process", {
  exports: {
    spawnSync: (_command: string, args: string[]) => {
      assert.equal(_command, "git", "only git may run synchronously");
      if (args.includes("--show-toplevel")) return { status: 0, stdout: "/repo" };
      if (args.includes("--quiet")) return { status: 1, stdout: "" };
      if (args[0] === "ls-files") return { status: 0, stdout: "" };
      return { status: 0, stdout: diff };
    },
    spawn: (command: string, args: string[], options: any) => {
      events.push("spawn");
      invocation = { command, args, options };
      assert.equal(events.at(-2), "stop", "terminal must be released before spawning");
      if (outcome.throws) throw new Error("synchronous spawn failure");
      const child = new EventEmitter();
      queueMicrotask(() => {
        if (outcome.error) child.emit("error", new Error(outcome.error));
        else {
          if (annotate) buffer = buffer.replace("+new", "+new\n#$# Fix this hunk");
          child.emit("close", outcome.code ?? null, outcome.signal ?? null);
        }
      });
      return child;
    },
  },
});
mock.module("node:fs", {
  exports: {
    mkdtempSync: () => "/tmp/review with spaces",
    writeFileSync: (_file: string, text: string) => {
      if (fileError === "write") throw new Error("write failed");
      buffer = text;
    },
    readFileSync: () => {
      if (fileError === "read") throw new Error("read failed");
      return buffer;
    },
    rmSync: () => { events.push("cleanup"); },
  },
});
const { default: extension } = await import("../extensions/vim-review.ts");

async function run(options: {
  outcome?: typeof outcome; fileError?: typeof fileError; annotate?: boolean;
  visual?: string; editor?: string; mode?: string;
} = {}) {
  events = [];
  outcome = options.outcome ?? { code: 0 };
  fileError = options.fileError;
  annotate = options.annotate ?? true;
  const notifications: [string, string][] = [];
  let prompt = "existing prompt";
  let handler: any;
  extension({ registerCommand: (_name: string, command: any) => { handler = command.handler; } } as any);
  const previous = { VISUAL: process.env.VISUAL, EDITOR: process.env.EDITOR };
  delete process.env.VISUAL;
  delete process.env.EDITOR;
  if (options.visual !== undefined) process.env.VISUAL = options.visual;
  if (options.editor !== undefined) process.env.EDITOR = options.editor;
  try {
    await handler("", {
      mode: options.mode ?? "tui", cwd: "/repo", waitForIdle: async () => {},
      ui: {
        notify: (text: string, level: string) => notifications.push([text, level]),
        setEditorText: (text: string) => { prompt = text; },
        custom: async (factory: any) => {
          let result: any;
          const component = await factory({
            stop: () => events.push("stop"),
            start: () => events.push("start"),
            requestRender: (force: boolean) => {
              assert.equal(force, true);
              events.push("render");
            },
          }, {}, {}, (value: any) => { events.push("done"); result = value; });
          assert.deepEqual(component.render(), []);
          return result;
        },
      },
    });
    return { notifications, prompt };
  } finally {
    for (const [key, value] of Object.entries(previous)) {
      if (value === undefined) delete process.env[key];
      else process.env[key] = value;
    }
  }
}

test("restores TUI before completion and preserves commented-hunk review behavior", async () => {
  const { prompt } = await run({ visual: "'/Applications/My Editor/bin/vim' --clean", editor: "ignored" });
  assert.deepEqual(events, ["stop", "spawn", "start", "render", "done", "cleanup"]);
  assert.equal(invocation.command, "/bin/sh");
  assert.equal(invocation.args[1], 'exec \'/Applications/My Editor/bin/vim\' --clean "$@"');
  assert.deepEqual(invocation.args.slice(2), [
    "vim-review", "-c",
    "setlocal filetype=diff number cursorline signcolumn=no nowrap foldmethod=syntax",
    "-c", "normal! gg", "/tmp/review with spaces/annotated.diff",
  ]);
  assert.deepEqual(invocation.options, { cwd: "/repo", stdio: "inherit" });
  assert.match(prompt, /annotated git diff/);
  assert.match(prompt, /#\$# Fix this hunk/);
  assert.doesNotMatch(prompt, /other|Add review comments/);
});

test("uses EDITOR with arguments, then falls back to vim", async () => {
  await run({ editor: "nvim -u NONE" });
  assert.equal(invocation.args[1], 'exec nvim -u NONE "$@"');
  await run();
  assert.equal(invocation.args[1], 'exec vim "$@"');
});

for (const [name, failure, message] of [
  ["spawn error", { error: "ENOENT" }, /ENOENT/],
  ["synchronous spawn throw", { throws: true }, /synchronous spawn failure/],
  ["missing editor", { code: 127 }, /code 127/],
  ["editor failure", { code: 2 }, /code 2/],
  ["signal", { signal: "SIGTERM" }, /SIGTERM/],
] as const) {
  test(`${name} restores terminal and reports failure, not cancellation`, async () => {
    const { notifications, prompt } = await run({ outcome: failure });
    assert.deepEqual(events.slice(0, 4), ["stop", "spawn", "start", "render"]);
    assert.equal(events.at(-1), "cleanup");
    assert.equal(prompt, "existing prompt");
    assert.equal(notifications.at(-1)![1], "error");
    assert.match(notifications.at(-1)![0], message);
    assert.doesNotMatch(notifications.at(-1)![0], /cancelled/);
  });
}

test(":cq cancellation and uncommented diff leave prompt unchanged", async () => {
  const cancelled = await run({ outcome: { code: 1 } });
  assert.equal(cancelled.prompt, "existing prompt");
  assert.deepEqual(cancelled.notifications.at(-1), ["vim-review cancelled", "info"]);
  const empty = await run({ annotate: false });
  assert.equal(empty.prompt, "existing prompt");
  assert.match(empty.notifications.at(-1)![0], /No review comments/);
});

test("file failures clean up and do not alter prompt", async () => {
  for (const failure of ["write", "read"] as const) {
    const result = await run({ fileError: failure });
    assert.equal(result.prompt, "existing prompt");
    assert.equal(result.notifications.at(-1)![1], "error");
    assert.equal(events.at(-1), "cleanup");
    if (failure === "write") assert.deepEqual(events, ["cleanup"]);
    else assert.ok(events.includes("render"));
  }
});

test("non-TUI mode never launches the editor", async () => {
  const result = await run({ mode: "rpc" });
  assert.deepEqual(events, []);
  assert.equal(result.prompt, "existing prompt");
  assert.equal(result.notifications.at(-1)![1], "error");
});
