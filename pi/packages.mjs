import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, resolve } from "node:path";

const home = homedir();
const agentDir = resolve(home, ".pi/agent");
const settingsPath = resolve(agentDir, "settings.json");
const settings = existsSync(settingsPath)
  ? JSON.parse(readFileSync(settingsPath, "utf8"))
  : {};

const localFut = resolve(home, "dev/fut");
const packages = [
  { source: "git:github.com/mikker/pineapple", themes: [] },
  { source: "git:github.com/mikker/codex-booster" },
  { source: "~/.dotfiles/pi", extensions: [] },
  {
    source: existsSync(localFut) ? localFut : "git:github.com/mikker/fut",
    skills: [],
  },
];

function identity(source) {
  if (source.startsWith("git:") || source.startsWith("npm:")) return source;
  const path = source.startsWith("~/")
    ? resolve(home, source.slice(2))
    : resolve(agentDir, source);
  return path === localFut ? "git:github.com/mikker/fut" : path;
}

settings.packages ??= [];
for (const pkg of packages) {
  const installed = settings.packages.some((entry) =>
    identity(typeof entry === "string" ? entry : entry.source) === identity(pkg.source),
  );
  if (!installed) settings.packages.push(pkg);
}

mkdirSync(dirname(settingsPath), { recursive: true });
writeFileSync(settingsPath, `${JSON.stringify(settings, null, 2)}\n`);
