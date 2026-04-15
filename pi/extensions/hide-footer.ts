import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const emptyFooter = () => ({
  render() {
    return [];
  },
  invalidate() {},
});

export default function hideFooterExtension(pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setFooter(emptyFooter);
  });
}
