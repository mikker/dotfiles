import type { ExtensionAPI, ReadToolDetails, ToolRenderContext } from "@mariozechner/pi-coding-agent";
import { createReadTool } from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";

function getLineCount(text: string): number {
	if (text.length === 0) return 0;
	return text.split("\n").length;
}

function renderStatusDot(theme: Parameters<NonNullable<ExtensionAPI["registerTool"]>>[0]["renderCall"] extends (args: any, theme: infer T, context: any) => any ? T : never, context: ToolRenderContext): string {
	if (context.isError) return theme.fg("error", "●");
	if (context.executionStarted && !context.isPartial) return theme.fg("success", "●");
	return theme.fg("warning", "●");
}

export default function readSummaryExtension(pi: ExtensionAPI) {
	pi.registerTool({
		name: "read",
		label: "read",
		description: "Read file contents. UI rendering shows a compact summary instead of file content previews.",
		parameters: createReadTool(process.cwd()).parameters,

		async execute(toolCallId, params, signal, onUpdate, ctx) {
			const tool = createReadTool(ctx.cwd);
			return tool.execute(toolCallId, params, signal, onUpdate);
		},

		renderCall(args, theme, context) {
			let text = `${renderStatusDot(theme, context)} `;
			text += theme.fg("toolTitle", theme.bold("read "));
			text += theme.fg("accent", args.path);
			if (args.offset || args.limit) {
				const parts: string[] = [];
				if (args.offset) parts.push(`offset=${args.offset}`);
				if (args.limit) parts.push(`limit=${args.limit}`);
				text += theme.fg("dim", ` (${parts.join(", ")})`);
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, { isPartial }, theme) {
			if (isPartial) return new Text(theme.fg("warning", "Reading..."), 0, 0);

			const content = result.content[0];
			const details = result.details as ReadToolDetails | undefined;

			if (content?.type === "image") {
				return new Text(theme.fg("success", "Image loaded"), 0, 0);
			}

			if (content?.type !== "text") {
				return new Text(theme.fg("muted", "Read complete"), 0, 0);
			}

			const lineCount = getLineCount(content.text);
			const byteCount = Buffer.byteLength(content.text, "utf8");
			let text = theme.fg("success", `Read ${lineCount} lines`);
			text += theme.fg("dim", ` (${byteCount} bytes shown)`);

			if (details?.truncation?.truncated) {
				text += theme.fg(
					"warning",
					` • truncated from ${details.truncation.totalLines} lines / ${details.truncation.totalBytes} bytes`,
				);
			}

			return new Text(text, 0, 0);
		},
	});
}
