#!/usr/bin/env node

import { spawn, execSync } from "node:child_process";
import { existsSync, rmSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const args = new Set(process.argv.slice(2));
const useProfile = args.has("--profile");

const unknownArgs = [...args].filter((arg) => arg !== "--profile");
if (unknownArgs.length > 0) {
  console.log("Usage: start.js [--profile]");
  console.log("\nOptions:");
  console.log(
    "  --profile  Copy your default Chrome profile (cookies, logins)",
  );
  console.log("\nExamples:");
  console.log("  start.js            # Start with fresh profile");
  console.log("  start.js --profile  # Start with your Chrome profile");
  process.exit(1);
}

async function isDebugEndpointUp() {
  try {
    const response = await fetch("http://localhost:9222/json/version");
    return response.ok;
  } catch {
    return false;
  }
}

// If something is already listening on :9222, reuse it instead of killing Chrome.
if (await isDebugEndpointUp()) {
  console.log("✓ Chrome already running on :9222 (reusing existing instance)");
  process.exit(0);
}

// Setup profile directory
execSync("mkdir -p ~/.cache/scraping", { stdio: "ignore" });

if (useProfile) {
  // Sync profile with rsync (much faster on subsequent runs)
  execSync(
    `rsync -a --delete --exclude 'Singleton*' --exclude 'DevToolsActivePort*' "${process.env["HOME"]}/Library/Application Support/Google/Chrome/" ~/.cache/scraping/`,
    { stdio: "pipe" },
  );
}

// Remove stale singleton/debug artifacts that can make Chrome forward to an
// already running browser instance (which drops our debug flags).
for (const staleFile of [
  "SingletonCookie",
  "SingletonLock",
  "SingletonSocket",
  "DevToolsActivePort",
  "DevToolsActivePort.lock",
]) {
  try {
    rmSync(`${process.env["HOME"]}/.cache/scraping/${staleFile}`, { force: true });
  } catch {
    // ignore
  }
}

function resolveChromeBinary() {
  if (process.env.BROWSER_BIN && existsSync(process.env.BROWSER_BIN)) {
    return process.env.BROWSER_BIN;
  }

  const candidates = [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary",
  ];

  return candidates.find((path) => existsSync(path)) || null;
}

const chromeBinary = resolveChromeBinary();

if (!chromeBinary) {
  console.error("✗ Could not find Chrome/Chromium binary");
  console.error("  Set BROWSER_BIN=/path/to/chrome and retry");
  process.exit(1);
}

const chromeArgs = [
  "--remote-debugging-port=9222",
  `--user-data-dir=${process.env["HOME"]}/.cache/scraping`,
  "--profile-directory=Default",
  "--disable-search-engine-choice-screen",
  "--no-first-run",
  "--disable-features=ProfilePicker",
];

const chromeProc = spawn(chromeBinary, chromeArgs, { detached: true, stdio: "ignore" });
chromeProc.unref();

// Wait for Chrome to be ready by checking the debugging endpoint
let connected = false;
for (let i = 0; i < 30; i++) {
  try {
    const response = await fetch("http://localhost:9222/json/version");
    if (response.ok) {
      connected = true;
      break;
    }
  } catch {
    // ignore; wait below
  }
  await new Promise((r) => setTimeout(r, 500));
}

if (!connected) {
  console.error("✗ Failed to connect to Chrome on :9222");
  console.error(`  Attempted binary: ${chromeBinary}`);
  process.exit(1);
}

// Start background watcher for logs/network (detached)
const scriptDir = dirname(fileURLToPath(import.meta.url));
const watcherPath = join(scriptDir, "watch.js");
spawn(process.execPath, [watcherPath], { detached: true, stdio: "ignore" }).unref();

console.log(
  `✓ Chrome started on :9222${useProfile ? " with your profile" : ""}`,
);
