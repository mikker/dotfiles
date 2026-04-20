#!/usr/bin/env -S npx tsx
/**
 * Create an HTML wrapper for an SVG to enable high-quality PNG capture
 *
 * Usage:
 *   bun run create-html.ts --svg diagram.svg --output diagram.html
 *   bun run create-html.ts --svg diagram.svg --output diagram.html --padding 40
 *
 * Runtimes:
 *   bun run create-html.ts ...
 *   npx tsx create-html.ts ...
 *   deno run --allow-read --allow-write create-html.ts ...
 */

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { resolve, basename } from "node:path";

interface Args {
  svg: string;
  output: string;
  padding: number;
  background?: string;
}

function parseArgs(): Args {
  const args = process.argv.slice(2);
  const result: Partial<Args> = { padding: 40 };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    const next = args[i + 1];

    switch (arg) {
      case "--svg":
      case "-s":
        result.svg = next;
        i++;
        break;
      case "--output":
      case "-o":
        result.output = next;
        i++;
        break;
      case "--padding":
      case "-p":
        result.padding = parseInt(next, 10) || 40;
        i++;
        break;
      case "--background":
      case "-b":
        result.background = next;
        i++;
        break;
      case "--help":
      case "-h":
        printHelp();
        process.exit(0);
    }
  }

  if (!result.svg) {
    console.error("Error: --svg is required");
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
SVG to HTML Wrapper

Creates a minimal HTML file for screenshot capture of SVG diagrams.

Usage:
  create-html.ts --svg <file.svg> --output <file.html> [options]

Options:
  -s, --svg <file>         Input SVG file
  -o, --output <file>      Output HTML file
  -p, --padding <pixels>   Padding around SVG (default: 40)
  -b, --background <color> Background colour (auto-detected from SVG)
  -h, --help               Show this help

Examples:
  create-html.ts --svg diagram.svg --output diagram.html
  create-html.ts --svg diagram.svg --output diagram.html --padding 60
  create-html.ts --svg diagram.svg --output diagram.html --background "#1a1b26"
`);
}

function extractBackgroundFromSvg(svgContent: string): string | null {
  // Try to extract background from SVG style or rect
  const bgMatch = svgContent.match(/background(?:-color)?:\s*([^;"\s]+)/i);
  if (bgMatch) return bgMatch[1];

  // Check for a background rect
  const rectMatch = svgContent.match(
    /<rect[^>]*fill="([^"]+)"[^>]*(?:width="100%"|height="100%")/i
  );
  if (rectMatch) return rectMatch[1];

  // Check style attribute on svg element
  const svgStyleMatch = svgContent.match(
    /<svg[^>]*style="[^"]*background(?:-color)?:\s*([^;"\s]+)/i
  );
  if (svgStyleMatch) return svgStyleMatch[1];

  return null;
}

function main(): void {
  const args = parseArgs();

  const svgPath = resolve(args.svg);
  if (!existsSync(svgPath)) {
    console.error(`SVG file not found: ${svgPath}`);
    process.exit(1);
  }

  const svgContent = readFileSync(svgPath, "utf-8");

  // Determine background colour
  const background =
    args.background ?? extractBackgroundFromSvg(svgContent) ?? "#ffffff";

  // Create HTML wrapper optimised for high-resolution screenshot
  // SVG renders at natural size with generous padding, no constraints
  const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${basename(args.svg, ".svg")}</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    html, body {
      background: ${background};
    }
    .container {
      padding: ${args.padding}px;
      display: inline-block;
      background: ${background};
    }
    .container svg {
      display: block;
      min-width: 1200px;
      height: auto;
    }
  </style>
</head>
<body>
  <div class="container">
    ${svgContent}
  </div>
</body>
</html>`;

  const outputPath = resolve(args.output);
  writeFileSync(outputPath, html, "utf-8");

  console.log(`HTML wrapper written to: ${outputPath}`);
  console.log(`Background colour: ${background}`);
}

main();
