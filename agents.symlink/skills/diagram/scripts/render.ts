import { render, PeleError } from "pele@1.6.0";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve, dirname, basename, join } from "node:path";

const args = process.argv.slice(2);
const [input, output, ...flags] = args;
let dark = false;
let maxWidth: number | undefined;

function fail(message: string): never {
  console.error(message);
  process.exit(1);
}

if (!input || !output || !output.endsWith(".svg")) {
  fail("Usage: bun render.ts input.mmd output.svg [--dark] [--width pixels]");
}
for (let i = 0; i < flags.length; i++) {
  if (flags[i] === "--dark") dark = true;
  else if (flags[i] === "--width") {
    maxWidth = Number(flags[++i]);
    if (!Number.isFinite(maxWidth) || maxWidth <= 0) fail("--width must be positive pixels");
  } else fail(`Unknown option: ${flags[i]}`);
}

const svgPath = resolve(output);
const htmlPath = join(dirname(svgPath), basename(svgPath, ".svg") + ".html");
if ([svgPath, htmlPath].includes(resolve(input))) fail("Output would overwrite source");

const colors = dark
  ? ["#171717", "#e5e5e5", "#a3a3a3", "#d4d4d4", "#262626", "#303030", "#737373", "#93c5fd"]
  : ["#ffffff", "#262626", "#737373", "#525252", "#f5f5f5", "#eeeeee", "#a3a3a3", "#2563eb"];
const names = ["bg", "fg", "muted", "line", "surface", "surface-alt", "border", "accent"];
const theme = names.map((name, i) => `--pele-${name}:${colors[i]}`).join(";");

try {
  const source = readFileSync(input, "utf8");
  const result = render(source, {
    responsive: false,
    maxWidth,
    fontFamily: "Arial, sans-serif",
    links: false,
    images: false,
    idPrefix: "diagram",
  });
  // Put the theme in the artifact itself, not just the HTML wrapper.
  const svg = result.svg.replace('style="', `style="${theme};background:${colors[0]};`);
  const html = `<!doctype html>
<html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width">
<title>Diagram</title>
<style>body{margin:0;padding:32px;background:${colors[0]};color:${colors[1]};font-family:Arial,sans-serif}svg{display:block;max-width:100%;height:auto}</style>
<body>${svg}</body></html>\n`;
  mkdirSync(dirname(svgPath), { recursive: true });
  writeFileSync(svgPath, svg + "\n");
  writeFileSync(htmlPath, html);
  console.log(`${result.type}: ${result.width}×${result.height}\n${svgPath}\n${htmlPath}`);
} catch (error) {
  if (error instanceof PeleError) fail(`${error.code}: ${error.message}`);
  throw error;
}
