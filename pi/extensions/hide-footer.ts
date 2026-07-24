import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const emptyFooter = () => ({
  render() {
    return [];
  },
  invalidate() {},
});

export default function hideFooterExtension(pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode === "tui") ctx.ui.setFooter(emptyFooter);
  });
}
