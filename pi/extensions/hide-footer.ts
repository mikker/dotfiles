import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function hideFooterExtension(pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.setFooter(() => ({
			render() {
				return [];
			},
			invalidate() {},
		}));
	});
}
