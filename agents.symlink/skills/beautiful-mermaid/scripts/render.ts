#!/usr/bin/env -S npx tsx
/**
 * Render a Mermaid diagram to SVG using Beautiful Mermaid
 *
 * Usage:
 *   bun run render.ts --input diagram.mmd --output diagram --theme tokyo-night
 *   bun run render.ts --code "graph TD; A-->B" --output diagram
 *
 * Runtimes:
 *   bun run render.ts ...
 *   npx tsx render.ts ...
 *   deno run --allow-read --allow-write --allow-net render.ts ...
 *
 * Output:
 *   Produces <output>.svg
 */

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { resolve } from "node:path";

const THEMES = [
  "default",
  "dracula",
  "solarized",
  "zinc-dark",
  "tokyo-night",
  "tokyo-night-storm",
  "tokyo-night-light",
  "catppuccin-latte",
  "nord",
  "nord-light",
  "github-dark",
  "github-light",
  "one-dark",
] as const;

type Theme = (typeof THEMES)[number];

interface Args {
  input?: string;
  code?: string;
  output: string;
  theme: Theme;
}

function parseArgs(): Args {
  const args = process.argv.slice(2);
  const result: Partial<Args> = { theme: "default" };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    const next = args[i + 1];

    switch (arg) {
      case "--input":
      case "-i":
        result.input = next;
        i++;
        break;
      case "--code":
      case "-c":
        result.code = next;
        i++;
        break;
      case "--output":
      case "-o":
        result.output = next;
        i++;
        break;
      case "--theme":
      case "-t":
        if (next && THEMES.includes(next as Theme)) {
          result.theme = next as Theme;
        } else {
          console.error(`Invalid theme: ${next}`);
          console.error(`Available themes: ${THEMES.join(", ")}`);
          process.exit(1);
        }
        i++;
        break;
      case "--help":
      case "-h":
        printHelp();
        process.exit(0);
    }
  }

  if (!result.input && !result.code) {
    console.error("Error: Either --input or --code is required");
    printHelp();
    process.exit(1);
  }

  if (!result.output) {
    console.error("Error: --output is required");
    printHelp();
    process.exit(1);
  }

  return result as Args;
}

function printHelp(): void {
  console.log(`
Beautiful Mermaid Renderer

Renders Mermaid diagrams to SVG.

Usage:
  render.ts --input <file.mmd> --output <basename> [--theme <theme>]
  render.ts --code "<mermaid code>" --output <basename> [--theme <theme>]

Options:
  -i, --input <file>    Input Mermaid file (.mmd)
  -c, --code <string>   Mermaid code as string
  -o, --output <name>   Output base name (without extension)
  -t, --theme <theme>   Theme name (default: default)
  -h, --help            Show this help

Available themes:
  ${THEMES.join(", ")}

Output:
  Produces <output>.svg

Examples:
  render.ts -i diagram.mmd -o diagram -t tokyo-night
  render.ts -c "graph TD; A-->B" -o simple
`);
}

function detectRuntime(): "bun" | "deno" | "node" {
  if (typeof (globalThis as any).Bun !== "undefined") return "bun";
  if (typeof (globalThis as any).Deno !== "undefined") return "deno";
  return "node";
}

async function ensurePackage(name: string): Promise<any> {
  const runtime = detectRuntime();

  try {
    if (runtime === "deno") {
      return await import(`npm:${name}`);
    }
    return await import(name);
  } catch {
    console.error(`${name} not found. Installing...`);

    const { execSync } = await import("node:child_process");

    try {
      if (runtime === "bun") {
        execSync(`bun add ${name}`, { stdio: "inherit" });
      } else if (runtime === "deno") {
        return await import(`npm:${name}`);
      } else {
        execSync(`npm install ${name}`, { stdio: "inherit" });
      }
      return await import(name);
    } catch (installError) {
      console.error(`Failed to install ${name}:`, installError);
      process.exit(1);
    }
  }
}

function getThemeConfig(themeName: Theme): { bg: string; fg: string } {
  const themeConfigs: Record<Theme, { bg: string; fg: string }> = {
    default: { bg: "#f5f5f5", fg: "#333333" },
    dracula: { bg: "#282a36", fg: "#f8f8f2" },
    solarized: { bg: "#fdf6e3", fg: "#657b83" },
    "zinc-dark": { bg: "#18181b", fg: "#fafafa" },
    "tokyo-night": { bg: "#1a1b26", fg: "#a9b1d6" },
    "tokyo-night-storm": { bg: "#24283b", fg: "#a9b1d6" },
    "tokyo-night-light": { bg: "#d5d6db", fg: "#343b58" },
    "catppuccin-latte": { bg: "#eff1f5", fg: "#4c4f69" },
    nord: { bg: "#2e3440", fg: "#eceff4" },
    "nord-light": { bg: "#eceff4", fg: "#2e3440" },
    "github-dark": { bg: "#0d1117", fg: "#c9d1d9" },
    "github-light": { bg: "#ffffff", fg: "#24292f" },
    "one-dark": { bg: "#282c34", fg: "#abb2bf" },
  };

  return themeConfigs[themeName];
}

async function main(): Promise<void> {
  const args = parseArgs();

  let mermaidCode: string;
  if (args.input) {
    const inputPath = resolve(args.input);
    if (!existsSync(inputPath)) {
      console.error(`Input file not found: ${inputPath}`);
      process.exit(1);
    }
    mermaidCode = readFileSync(inputPath, "utf-8");
  } else {
    mermaidCode = args.code!;
  }

  console.log(`Rendering diagram with theme: ${args.theme}`);

  const beautifulMermaid = await ensurePackage("beautiful-mermaid");
  const renderMermaid = beautifulMermaid.renderMermaid;
  const THEMES = beautifulMermaid.THEMES;

  const themeConfig = THEMES?.[args.theme] ?? getThemeConfig(args.theme);
  console.log(`Using theme: bg=${themeConfig.bg}, fg=${themeConfig.fg}`);

  const svg = await renderMermaid(mermaidCode, themeConfig);

  const svgPath = resolve(`${args.output}.svg`);
  writeFileSync(svgPath, svg, "utf-8");
  console.log(`SVG written to: ${svgPath}`);
}

main().catch((err) => {
  console.error("Error:", err.message);
  process.exit(1);
});
