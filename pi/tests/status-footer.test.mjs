import assert from "node:assert/strict";
import { test } from "node:test";
import { importExtension } from "./host.mjs";

const statusFooter = await importExtension(new URL("../extensions/status-footer.ts", import.meta.url).pathname);

test("footer shows context and speed without cost", () => {
  const handlers = new Map();
  const listeners = new Map();
  let footer;
  const theme = { fg: (_color, text) => text };
  statusFooter({
    on: (name, handler) => handlers.set(name, handler),
    events: { on: (name, handler) => { listeners.set(name, handler); return () => listeners.delete(name); }, emit() {} },
  });
  handlers.get("session_start")({}, {
    mode: "tui", cwd: "/tmp",
    ui: { setFooter: (factory) => { footer = factory({ requestRender() {} }, theme, { getExtensionStatuses: () => new Map() }); } },
  });
  listeners.get("dashboard:model-info")({ provider: "openai", modelId: "gpt-6.1-sol", thinking: "medium", contextWindow: 1000000, contextPercent: 25, cost: 123.45, tokensPerSecond: 42 });
  const output = footer.render(100).join("\n");
  assert.match(output, /25%\/1\.0m/);
  assert.match(output, /42 tok\/s/);
  assert.doesNotMatch(output, /\$|123\.45/);
});
