import type { AssistantMessage } from "@mariozechner/pi-ai";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

function formatCount(value: number | null | undefined): string {
	if (value == null) return "--";
	if (value < 1000) return `${value}`;
	if (value < 10000) return `${(value / 1000).toFixed(1)}k`;
	return `${Math.round(value / 1000)}k`;
}

export default function ampishUiExtension(pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (!ctx.hasUI) return;

		ctx.ui.setWorkingMessage(ctx.ui.theme.fg("muted", "Thinking"));
		ctx.ui.setHeader(undefined);
		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());
			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					let input = 0;
					let output = 0;
					let cost = 0;
					for (const entry of ctx.sessionManager.getBranch()) {
						if (entry.type === "message" && entry.message.role === "assistant") {
							const message = entry.message as AssistantMessage;
							input += message.usage.input;
							output += message.usage.output;
							cost += message.usage.cost.total;
						}
					}

					const usage = ctx.getContextUsage();
					const left = theme.fg(
						"dim",
						`${usage?.percent == null ? "--" : `${Math.round(usage.percent)}%`} · $${cost.toFixed(2)}`,
					);
					const branch = footerData.getGitBranch();
					const model = ctx.model?.id ?? "no-model";
					const right = [
						theme.fg("accent", model),
						theme.fg("dim", `${formatCount(input)}↑ ${formatCount(output)}↓`),
						branch ? theme.fg("dim", branch) : undefined,
					]
						.filter(Boolean)
						.join(theme.fg("dim", " · "));

					const pad = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
					return [truncateToWidth(left + pad + right, width)];
				},
			};
		});
	});
}
