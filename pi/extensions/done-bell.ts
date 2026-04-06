import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

function ringBell(): void {
	process.stdout.write("\x07");
}

export default function doneBellExtension(pi: ExtensionAPI) {
	pi.on("agent_end", async (_event, ctx) => {
		if (!ctx.hasUI) return;
		if (ctx.hasPendingMessages()) return;
		if (!process.stdout.isTTY) return;
		ringBell();
	});
}
