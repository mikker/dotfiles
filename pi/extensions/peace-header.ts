import { homedir } from "node:os";
import { relative } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

type Rgb = [number, number, number];
type GradientStop = { position: number; color: Rgb };

const RESET = "\x1b[0m";
const BOLD = "\x1b[1m";
const GRADIENT: GradientStop[] = [
  { position: 0, color: [172, 98, 237] },
  { position: 0.15, color: [78, 0, 224] },
  { position: 0.3, color: [56, 174, 244] },
  { position: 0.5, color: [75, 222, 121] },
  { position: 0.65, color: [255, 237, 38] },
  { position: 0.8, color: [255, 174, 95] },
  { position: 1, color: [255, 83, 83] },
];
const PEACE_SIGN = [
  "       ▓▓▓░     ▓▓▓▓▓▓▓▓",
  "    █▓▓▓▓▓▓▓▓  ▓▓▓▒   ▓▓▓",
  "    ▓▓▓    ▓▓▓ ▓▓▓     ▓▓░",
  "   ▓▓▓     ▓▓▓ ▓▓▓    ▓▓▓",
  "    ▓▓▓     ▓▓▓▓▓▒    ▓▓▓",
  "    ▓▓▓     ▓▓▓▓▓     ▓▓▓",
  "     ▓▓▓    ░▓▓▓▓     ▓▓▓▓▓▓",
  "     ▓▓▓     ▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓",
  "     ▒▓▓░    ▓▓▓▓   ▓▓▓    ▓▓▓▓▓▓▓▓▓",
  "      ▓▓▓     ▓▓█   ▓▓▓    ░▓▓▒   ▓▓▓",
  "      ▓▓▓    ▓▓▓    ▓▓▓    ░▓▓▒   ▓▓▓",
  "       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ░▓▓▒   ▓▓▓",
  "      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ░▓▓▒   ▓▓▓",
  "     ▒▓▓░              ▓▓▓░▓▓▓    ▓▓▓",
  "     ▓▓▓               ▓▓▓▓▓▓▓▓▓▓▓▓▓▓",
  "     ▓▓▓       ▓▓▓▓▓▓▓▓▓▓     ▓▓▓▓▓▓▓",
  "     ▓▓▓       ▓▓▓▓▓▓▓▓           ▓▓▓",
  "     ▓▓▓                          ▓▓▓",
  "      ▓▓▓                        ▓▓▓░",
  "      ▓▓▓░                       ▓▓▓",
  "       ▓▓▓▓                    ▓▓▓▓",
  "        ▒▓▓▓▓                ▓▓▓▓▓",
  "          ░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓",
  "              ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░",
];
const PEACE_SIGN_WIDTH = Math.max(...PEACE_SIGN.map(visibleWidth));

function mix(from: number, to: number, amount: number) {
  return Math.round(from + (to - from) * amount);
}

function sampleGradient(position: number): Rgb {
  const clamped = Math.max(0, Math.min(1, position));
  const nextIndex = GRADIENT.findIndex((stop) => stop.position >= clamped);
  const to = GRADIENT[Math.max(0, nextIndex)]!;
  const from = GRADIENT[Math.max(0, nextIndex - 1)]!;
  const amount = from === to ? 0 : (clamped - from.position) / (to.position - from.position);

  return [
    mix(from.color[0], to.color[0], amount),
    mix(from.color[1], to.color[1], amount),
    mix(from.color[2], to.color[2], amount),
  ];
}

function gradientText(text: string, row: number) {
  const characters = [...text];
  const verticalPosition = row / Math.max(PEACE_SIGN.length - 1, 1);

  return characters
    .map((character, index) => {
      if (character === " ") return character;
      const horizontalPosition = index / Math.max(PEACE_SIGN_WIDTH - 1, 1);
      const [red, green, blue] = sampleGradient(verticalPosition * 0.82 + horizontalPosition * 0.18);
      return `${BOLD}\x1b[38;2;${red};${green};${blue}m${character}${RESET}`;
    })
    .join("");
}

function formatDirectory(cwd: string) {
  const home = homedir();
  const label = cwd === home ? "~" : cwd.startsWith(`${home}/`) ? `~/${relative(home, cwd)}` : cwd;
  return label.replace(/[\u0000-\u001f\u007f-\u009f]/g, "");
}

export default function peaceHeader(pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setHeader((_tui, theme) => ({
      render(width: number) {
        const padding = " ".repeat(Math.max(0, Math.floor((width - PEACE_SIGN_WIDTH) / 2)));
        const art = PEACE_SIGN.map((line, row) =>
          truncateToWidth(`${padding}${gradientText(line, row)}`, width, ""),
        );
        const title = theme.bold(theme.fg("muted", formatDirectory(ctx.cwd)));
        const titlePadding = " ".repeat(Math.max(0, Math.floor((width - visibleWidth(title)) / 2)));

        return ["", ...art, "", truncateToWidth(`${titlePadding}${title}`, width, ""), ""];
      },
      invalidate() { },
    }));
  });
}
