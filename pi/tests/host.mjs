import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { join } from "node:path";

export const hostRoot = process.env.PI_TEST_HOST ?? join(
  execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim(),
  "@earendil-works/pi-coding-agent",
);
const require = createRequire(join(hostRoot, "package.json"));
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, {
  fsCache: false,
  alias: Object.fromEntries([
    "@earendil-works/pi-coding-agent",
    "@earendil-works/pi-tui",
    "@earendil-works/pi-agent-core",
    "@earendil-works/pi-ai",
    "typebox",
  ].map((name) => [name, name === "@earendil-works/pi-coding-agent"
    ? join(hostRoot, "dist", "index.js")
    : name.startsWith("@earendil-works/")
      ? join(hostRoot, "node_modules", name, "dist", "index.js")
      : require.resolve(name)])),
});

export const importExtension = (path) => jiti.import(path, { default: true });
