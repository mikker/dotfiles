// Not an extension entrypoint. Run: node --test tests/offline.test.mjs
// Uses the installed Pi package; no network, model, or session is required.
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import { createRequire, syncBuiltinESMExports } from "node:module";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { fileURLToPath } from "node:url";
import { test } from "node:test";

// Install stable wrappers before loading TS: transpilers may capture named
// builtin imports once. Fault injection then changes only the delegated hook.
const originals = { rm: fs.rm, writeFile: fs.writeFile, mkdir: fs.mkdir };
const hooks = {};
for (const name of Object.keys(originals)) {
  fs[name] = (...args) => hooks[name]
    ? hooks[name](originals[name], ...args)
    : originals[name](...args);
}
syncBuiltinESMExports();

const piRoot = process.env.PI_TEST_PACKAGE ??
  "/Users/mikker/.local/share/mise/installs/node/26.10.0/lib/node_modules/@earendil-works/pi-coding-agent";
const require = createRequire(join(piRoot, "package.json"));
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, {
  fsCache: false,
  alias: {
    "@earendil-works/pi-coding-agent": join(piRoot, "dist/index.js"),
    "@earendil-works/pi-tui": require.resolve("@earendil-works/pi-tui"),
    typebox: require.resolve("typebox"),
  },
});
const { applyHunks, ApplyPatchError } = await jiti.import(fileURLToPath(new URL("../apply.ts", import.meta.url)));
const { createApplyPatchToolDefinition } = await jiti.import(fileURLToPath(new URL("../tool.ts", import.meta.url)));
const { withFileMutationQueue, createWriteToolDefinition, createEditToolDefinition } = await import(join(piRoot, "dist/index.js"));
const chunk = (before, after) => ({ changeContext: null, oldLines: [before], newLines: [after], isEndOfFile: false });
const update = (path, before, after, movePath) => ({ type: "update", path, movePath, chunks: [chunk(before, after)] });
const deferred = () => {
  let resolve;
  const promise = new Promise((done) => { resolve = done; });
  return { promise, resolve };
};
async function sandbox(fn) {
  const cwd = await fs.mkdtemp(join(tmpdir(), "pi-apply-patch-"));
  try { await fn(cwd); } finally { await fs.rm(cwd, { recursive: true, force: true }); }
}
async function intercept(name, replacement, fn) {
  hooks[name] = replacement;
  try { await fn(); } finally { delete hooks[name]; }
}
const patch = (...lines) => ["*** Begin Patch", ...lines, "*** End Patch"].join("\n");
const execute = (cwd, input, signal, onUpdate) => createApplyPatchToolDefinition(cwd).execute("test", { input }, signal, onUpdate, { cwd });

test("JSON declaration agrees with schema; parse errors return isError and details", async () => {
  const tool = createApplyPatchToolDefinition(".");
  assert.equal(tool.parameters.properties.input.type, "string");
  assert.match(tool.description, /Pass a JSON object/);
  assert.ok(!tool.promptGuidelines.join("\n").includes("Do not wrap it in JSON"));
  const result = await execute(".", "invalid");
  assert.equal(result.isError, true);
  assert.equal(result.details.patch, "invalid");
  assert.deepEqual(result.details.summary, []);
});

test("relative path validation precedes all writes, for every operation and move", async () => sandbox(async (cwd) => {
  for (const bad of [join(cwd, "bad"), "C:\\absolute.txt", "\\\\server\\share\\file", ""]) {
    for (const hunk of [
      { type: "add", path: bad, contents: "bad" },
      { type: "delete", path: bad },
      update(bad, "a", "b"),
      update("source", "a", "b", bad),
    ]) {
      await assert.rejects(applyHunks([{ type: "add", path: "first", contents: "first" }, hunk], cwd), (error) => {
        assert.ok(error instanceof ApplyPatchError);
        assert.match(error.message, /must be relative/);
        assert.deepEqual(error.partial.summary, []);
        return true;
      });
      await assert.rejects(fs.stat(join(cwd, "first")), { code: "ENOENT" });
    }
  }
}));

test("successful add/update/move/delete with stable progress snapshots", async () => sandbox(async (cwd) => {
  const progress = [];
  const result = await applyHunks([
    { type: "add", path: "nested/a", contents: "old\n" },
    update("nested/a", "old", "new", "b"),
    { type: "delete", path: "b" },
  ], cwd, (partial) => progress.push(partial));
  assert.deepEqual(progress[0].summary, ["A nested/a"]);
  assert.deepEqual(result.affected.deleted, ["nested/a", "b"]);
  assert.equal(result.fileChanges.length, 4);
  await assert.rejects(fs.stat(join(cwd, "b")), { code: "ENOENT" });
}));

test("later failures preserve earlier summaries and diffs in final tool errors", async () => sandbox(async (cwd) => {
  const result = await execute(cwd, patch("*** Add File: first", "+one", "*** Delete File: missing"));
  assert.equal(result.isError, true);
  assert.deepEqual(result.details.summary, ["A first"]);
  assert.equal(result.details.fileDiffs[0].path, "first");
  assert.match(result.content[0].text, /partially applied/);
  assert.equal(await fs.readFile(join(cwd, "first"), "utf8"), "one\n");
}));

test("move removal failure reports destination and overwrite, not source deletion", async () => sandbox(async (cwd) => {
  await fs.writeFile(join(cwd, "source"), "old\n");
  await fs.writeFile(join(cwd, "dest"), "previous\n");
  await intercept("rm", async (original, path, options) => {
    if (path === join(cwd, "source")) throw new Error("source removal failed");
    return original(path, options);
  }, async () => {
    const result = await execute(cwd, patch("*** Update File: source", "*** Move to: dest", "@@", "-old", "+new"));
    assert.equal(result.isError, true);
    assert.deepEqual(result.details.summary, ["M dest", "O dest (overwrote existing)"]);
    assert.deepEqual(result.details.fileDiffs.map((diff) => diff.path), ["dest"]);
    assert.match(result.content[0].text, /already modified.*dest/);
  });
  assert.equal(await fs.readFile(join(cwd, "source"), "utf8"), "old\n");
  assert.equal(await fs.readFile(join(cwd, "dest"), "utf8"), "new\n");
}));

test("pre-abort and abort between hunks stop further mutation", async () => sandbox(async (cwd) => {
  const controller = new AbortController();
  controller.abort();
  const result = await execute(cwd, patch("*** Add File: never", "+no"), controller.signal);
  assert.equal(result.isError, true);
  assert.deepEqual(result.details.summary, []);
  const next = new AbortController();
  const partial = await execute(cwd, patch("*** Add File: first", "+yes", "*** Add File: never", "+no"), next.signal, () => next.abort());
  assert.equal(partial.isError, true);
  assert.deepEqual(partial.details.summary, ["A first"]);
  await assert.rejects(fs.stat(join(cwd, "never")), { code: "ENOENT" });
}));

test("queued abort waits for queue ownership then leaves file unchanged", async () => sandbox(async (cwd) => {
  const held = deferred(), release = deferred();
  const path = join(cwd, "a");
  await fs.writeFile(path, "old\n");
  const holder = withFileMutationQueue(path, async () => { held.resolve(); await release.promise; });
  await held.promise;
  const controller = new AbortController();
  const applying = execute(cwd, patch("*** Update File: a", "@@", "-old", "+new"), controller.signal);
  let settled = false;
  applying.then(() => { settled = true; });
  await new Promise((done) => setTimeout(done, 25));
  controller.abort();
  await new Promise((done) => setTimeout(done, 25));
  assert.equal(settled, false);
  release.resolve();
  await holder;
  const result = await applying;
  assert.equal(result.isError, true);
  assert.equal(await fs.readFile(path, "utf8"), "old\n");
}));

test("abort after mkdir prevents write; failed overwrite is not reported as completed", async () => sandbox(async (cwd) => {
  const controller = new AbortController();
  await intercept("mkdir", async (original, ...args) => {
    const result = await original(...args);
    controller.abort();
    return result;
  }, async () => {
    const result = await execute(cwd, patch("*** Add File: nested/a", "+new"), controller.signal);
    assert.equal(result.isError, true);
    assert.deepEqual(result.details.summary, []);
  });
  await assert.rejects(fs.stat(join(cwd, "nested/a")), { code: "ENOENT" });
  await fs.writeFile(join(cwd, "existing"), "old\n");
  await intercept("writeFile", async () => { throw new Error("write failed"); }, async () => {
    const result = await execute(cwd, patch("*** Add File: existing", "+new"));
    assert.equal(result.isError, true);
    assert.deepEqual(result.details.summary, []);
  });
  assert.equal(await fs.readFile(join(cwd, "existing"), "utf8"), "old\n");
}));

test("abort during source removal records both completed move mutations", async () => sandbox(async (cwd) => {
  await fs.writeFile(join(cwd, "source"), "old\n");
  const controller = new AbortController();
  await intercept("rm", async (original, path, options) => {
    const result = await original(path, options);
    controller.abort();
    return result;
  }, async () => {
    const result = await execute(cwd, patch("*** Update File: source", "*** Move to: dest", "@@", "-old", "+new"), controller.signal);
    assert.equal(result.isError, true);
    assert.deepEqual(result.details.summary, ["M dest", "D source"]);
    assert.deepEqual(result.details.fileDiffs.map((diff) => diff.path), ["dest", "source"]);
  });
}));

test("abort during destination write holds both queues and records destination only", async () => sandbox(async (cwd) => {
  await fs.writeFile(join(cwd, "source"), "old\n");
  const entered = deferred(), release = deferred();
  const controller = new AbortController();
  await intercept("writeFile", async (original, path, ...args) => {
    if (path === join(cwd, "dest")) { entered.resolve(); await release.promise; }
    return original(path, ...args);
  }, async () => {
    const applying = execute(cwd, patch("*** Update File: source", "*** Move to: dest", "@@", "-old", "+new"), controller.signal);
    await entered.promise;
    controller.abort();
    let sourceAcquired = false, destAcquired = false;
    const sourceWait = withFileMutationQueue(join(cwd, "source"), async () => { sourceAcquired = true; });
    const destWait = withFileMutationQueue(join(cwd, "dest"), async () => { destAcquired = true; });
    await new Promise((done) => setTimeout(done, 25));
    assert.equal(sourceAcquired, false);
    assert.equal(destAcquired, false);
    release.resolve();
    const result = await applying;
    assert.equal(result.isError, true);
    assert.deepEqual(result.details.summary, ["M dest"]);
    await Promise.all([sourceWait, destWait]);
  });
  assert.equal(await fs.readFile(join(cwd, "source"), "utf8"), "old\n");
  assert.equal(await fs.readFile(join(cwd, "dest"), "utf8"), "new\n");
}));

test("built-in write/edit share queues with patch read-modify-write", async () => sandbox(async (cwd) => {
  const entered = deferred(), release = deferred();
  const path = join(cwd, "a");
  const writer = createWriteToolDefinition(cwd, { operations: {
    mkdir: async () => {},
    writeFile: async (path, content) => { entered.resolve(); await release.promise; await fs.writeFile(path, content); },
  }});
  const writing = writer.execute("write", { path: "a", content: "old\n" }, undefined, undefined, { cwd });
  await entered.promise;
  const applying = applyHunks([update("a", "old", "new")], cwd);
  release.resolve();
  await writing;
  await applying;
  const editingEntered = deferred(), editingRelease = deferred();
  const editor = createEditToolDefinition(cwd, { operations: {
    access: async () => {},
    readFile: (path) => fs.readFile(path),
    writeFile: async (path, content) => { editingEntered.resolve(); await editingRelease.promise; await fs.writeFile(path, content); },
  }});
  const editing = editor.execute("edit", { path: "a", edits: [{ oldText: "new", newText: "edited" }] }, undefined, undefined, { cwd });
  await editingEntered.promise;
  const patching = applyHunks([update("a", "edited", "final")], cwd);
  editingRelease.resolve();
  await editing;
  await patching;
  assert.equal(await fs.readFile(path, "utf8"), "final\n");
}));

test("same-path aliases rejected; opposite moves finish without deadlock", { timeout: 3000 }, async () => sandbox(async (cwd) => {
  await fs.writeFile(join(cwd, "a"), "old\n");
  await fs.symlink("a", join(cwd, "alias"));
  for (const dest of ["./a", "alias"]) {
    await assert.rejects(applyHunks([update("a", "old", "new", dest)], cwd), /same as the source/);
    assert.equal(await fs.readFile(join(cwd, "a"), "utf8"), "old\n");
  }
  await fs.writeFile(join(cwd, "b"), "old\n");
  const results = await Promise.allSettled([
    applyHunks([update("a", "old", "new", "b")], cwd),
    applyHunks([update("b", "old", "new", "a")], cwd),
  ]);
  assert.ok(results.some((result) => result.status === "fulfilled"));
}));
