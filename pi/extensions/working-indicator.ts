import type {
  ExtensionAPI,
  ExtensionContext,
  WorkingIndicatorOptions,
} from "@mariozechner/pi-coding-agent";

type IndicatorMode = "dot" | "pulse" | "minimal" | "none" | "default";

const ASTERISK = "❋ ";
const ANSI_RESET = "\x1b[39m";
const RAINBOW_COLORS = [31, 33, 32, 36, 34, 35];

function colorize(text: string, color: number): string {
  return `\x1b[${color}m${text}${ANSI_RESET}`;
}

function rainbowFrames(): string[] {
  return RAINBOW_COLORS.map((color) => colorize(ASTERISK, color));
}

function indicator(
  ctx: ExtensionContext,
  mode: IndicatorMode,
): WorkingIndicatorOptions | undefined {
  const { theme } = ctx.ui;

  switch (mode) {
    case "dot":
      return { frames: [theme.fg("accent", ASTERISK)] };
    case "pulse":
      return {
        frames: rainbowFrames(),
        intervalMs: 90,
      };
    case "minimal":
      return {
        frames: [
          theme.fg("dim", ASTERISK),
          theme.fg("muted", ASTERISK),
          theme.fg("accent", ASTERISK),
        ],
        intervalMs: 120,
      };
    case "none":
      return { frames: [] };
    case "default":
      return undefined;
  }
}

function describe(mode: IndicatorMode): string {
  switch (mode) {
    case "dot":
      return "dot";
    case "pulse":
      return "pulse";
    case "minimal":
      return "minimal";
    case "none":
      return "hidden";
    case "default":
      return "pi default";
  }
}

export default function (pi: ExtensionAPI) {
  let mode: IndicatorMode = "pulse";

  function apply(ctx: ExtensionContext) {
    ctx.ui.setWorkingIndicator(indicator(ctx, mode));
    ctx.ui.setStatus(
      "working-indicator",
      ctx.ui.theme.fg("dim", `indicator ${describe(mode)}`),
    );
  }

  pi.on("session_start", async (_event, ctx) => {
    apply(ctx);
  });

  pi.registerCommand("working-indicator", {
    description: "Set streaming indicator: dot, pulse, minimal, none, reset.",
    handler: async (args, ctx) => {
      const next = args.trim().toLowerCase();
      if (!next) {
        ctx.ui.notify(`Working indicator: ${describe(mode)}`, "info");
        return;
      }

      if (
        next !== "dot" &&
        next !== "pulse" &&
        next !== "minimal" &&
        next !== "none" &&
        next !== "reset"
      ) {
        ctx.ui.notify(
          "Usage: /working-indicator [dot|pulse|minimal|none|reset]",
          "error",
        );
        return;
      }

      mode = next === "reset" ? "default" : (next as IndicatorMode);
      apply(ctx);
      ctx.ui.notify(`Working indicator set to ${describe(mode)}`, "info");
    },
  });
}
