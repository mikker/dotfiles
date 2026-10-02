import assert from "node:assert/strict";
import { mkdtemp, mkdir, writeFile, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";
import { importExtension } from "./host.mjs";

const inlineSkills = await importExtension(new URL("../extensions/inline-skills.ts", import.meta.url).pathname);

test("inline skills preserve skill directories and native commands", async () => {
  const root = await mkdtemp(join(tmpdir(), "pi-inline-skills-"));
  try {
    const commands = [];
    for (const name of ["first", "second"]) {
      const directory = join(root, "skills", name);
      await mkdir(directory, { recursive: true });
      const path = join(directory, "SKILL.md");
      await writeFile(path, `---\nname: ${name}\ndescription: Test\n---\nInstructions for ${name}.`);
      commands.push({ name: `skill:${name}`, source: "skill", sourceInfo: { path, baseDir: root } });
    }
    commands.push({ name: "review", source: "prompt", sourceInfo: { path: join(root, "review.md") } });
    const handlers = new Map();
    const notifications = [];
    inlineSkills({ getCommands: () => commands, on: (name, handler) => handlers.set(name, handler) });
    const ctx = { ui: { notify: (message) => notifications.push(message) } };
    const input = (text) => handlers.get("input")({ text, source: "interactive" }, ctx);

    assert.deepEqual(await input("$first hello"), { action: "transform", text: "/skill:first hello" });
    const ordinary = await input("Use $first and $second");
    assert.ok(ordinary.text.includes(`References are relative to ${join(root, "skills", "first")}.`));
    const combined = await input("/skill:first use $second");
    assert.match(combined.text, /Instructions for first/);
    assert.match(combined.text, /Instructions for second/);
    assert.doesNotMatch(combined.text, /\/skill:first/);
    assert.deepEqual(await input("/review use $first"), { action: "handled" });
    assert.match(notifications.at(-1), /prompt templates/);

    await rm(commands[0].sourceInfo.path);
    assert.deepEqual(await input("Use $first"), { action: "handled" });
    assert.match(notifications.at(-1), /Could not load inline skills/);
    assert.deepEqual(await input("Use $unknown"), { action: "continue" });
  } finally {
    await rm(root, { recursive: true, force: true });
  }
});
