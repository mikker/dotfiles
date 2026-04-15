import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

function shouldRingBell(hasUI: boolean, hasPendingMessages: boolean): boolean {
  return hasUI && !hasPendingMessages && process.stdout.isTTY;
}

export default function doneBellExtension(pi: ExtensionAPI) {
  pi.on("agent_end", async (_event, ctx) => {
    if (!shouldRingBell(ctx.hasUI, ctx.hasPendingMessages())) return;
    process.stdout.write("\x07");
  });
}
