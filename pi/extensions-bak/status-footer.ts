// Archived in favor of the shared Pi setup.
import type {
  ExtensionAPI,
  ReadonlyFooterDataProvider,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

export default function statusFooterExtension(pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setFooter((_tui, theme, footerData: ReadonlyFooterDataProvider) => ({
      render(width) {
        return Array.from(footerData.getExtensionStatuses().entries())
          .sort(([a], [b]) => a.localeCompare(b))
          .flatMap(([, text]) => text.split("\n"))
          .map((line) =>
            truncateToWidth(line, width, theme.fg("dim", "...")),
          );
      },
      invalidate() {},
    }));
  });
}
