import {
  createBashTool,
  createEditTool,
  createFindTool,
  createGrepTool,
  createLsTool,
  createReadTool,
  createWriteTool,
  type ExtensionAPI,
  type ExtensionContext,
  type ReadToolDetails,
} from "@earendil-works/pi-coding-agent";
import { Text, truncateToWidth } from "@earendil-works/pi-tui";
import { homedir } from "node:os";

const MAX_PREVIEW_CHARS = 8_000;

type ToolTheme = ExtensionContext["ui"]["theme"];
type ToolRenderContext = {
  isError: boolean;
  executionStarted: boolean;
  isPartial: boolean;
};

type ToolResult = {
  content?: Array<{ type: string; text?: string }>;
  details?: unknown;
};

function getTextContent(result: ToolResult): string {
  return result.content?.find((content) => content.type === "text")?.text ?? "";
}

function summarizeText(text: string) {
  return {
    lines: text ? text.split("\n").length : 0,
    bytes: Buffer.byteLength(text, "utf8"),
  };
}

function preview(text: string): string {
  if (text.length <= MAX_PREVIEW_CHARS) return text;
  return `${text.slice(0, MAX_PREVIEW_CHARS)}\n… (${text.length - MAX_PREVIEW_CHARS} characters hidden)`;
}

function compactResult(
  result: ToolResult,
  options: { expanded?: boolean; isPartial?: boolean },
  theme: ToolTheme,
  context: ToolRenderContext,
  pendingLabel: string,
  successLabel: string,
) {
  if (options.isPartial) return new Text(theme.fg("warning", pendingLabel), 0, 0);

  const text = getTextContent(result);
  if (context.isError) {
    return new Text(theme.fg("error", preview(text || "Tool failed")), 0, 0);
  }
  if (!options.expanded) return new Text("", 0, 0);
  if (!text) return new Text(theme.fg("success", successLabel), 0, 0);

  const summary = summarizeText(text);
  const output =
    theme.fg("success", successLabel) +
    theme.fg("dim", ` (${summary.lines} lines, ${summary.bytes} bytes)`) +
    `\n${theme.fg("toolOutput", preview(text))}`;
  return new Text(output, 0, 0);
}

function shortenPath(path: string): string {
  const home = homedir();
  return path.startsWith(home) ? `~${path.slice(home.length)}` : path;
}

function compactArg(value: unknown, width = 120): string {
  return truncateToWidth(String(value ?? ""), width, "…");
}

function renderStatusDot(theme: ToolTheme, context: ToolRenderContext): string {
  if (context.isError) return theme.fg("error", "●");
  if (context.executionStarted && !context.isPartial)
    return theme.fg("success", "●");
  return theme.fg("warning", "●");
}

const factories = {
  bash: createBashTool,
  edit: createEditTool,
  write: createWriteTool,
  read: createReadTool,
  find: createFindTool,
  grep: createGrepTool,
  ls: createLsTool,
};

type BuiltInToolName = keyof typeof factories;

type ToolSpec = {
  name: BuiltInToolName;
  pendingLabel: string;
  successLabel: string;
  renderCall: (args: any, theme: ToolTheme, context: ToolRenderContext) => Text;
  renderResult?: (
    result: ToolResult,
    options: { expanded?: boolean; isPartial?: boolean },
    theme: ToolTheme,
    context: ToolRenderContext,
  ) => Text;
};

function callHeader(
  name: string,
  detail: string,
  theme: ToolTheme,
  context: ToolRenderContext,
): Text {
  return new Text(
    `${renderStatusDot(theme, context)} ${theme.fg("toolTitle", theme.bold(`${name} `))}${theme.fg("accent", detail)}`,
    0,
    0,
  );
}

export default function toolCallDotsExtension(pi: ExtensionAPI) {
  const specs: ToolSpec[] = [
    {
      name: "bash",
      pendingLabel: "Running...",
      successLabel: "Done",
      renderCall(args, theme, context) {
        const detail = `${compactArg(args.command)}${
          args.timeout ? ` (${args.timeout}s)` : ""
        }`;
        return callHeader("bash", detail, theme, context);
      },
    },
    ...(["edit", "write"] as const).map((name) => ({
      name,
      pendingLabel: name === "edit" ? "Editing..." : "Writing...",
      successLabel: name === "edit" ? "Applied" : "Written",
      renderCall: (args: any, theme: ToolTheme, context: ToolRenderContext) =>
        callHeader(name, compactArg(shortenPath(args.path)), theme, context),
    })),
    {
      name: "read",
      pendingLabel: "Reading...",
      successLabel: "Read",
      renderCall(args, theme, context) {
        const range = [
          args.offset ? `offset=${args.offset}` : "",
          args.limit ? `limit=${args.limit}` : "",
        ].filter(Boolean);
        const detail = `${compactArg(shortenPath(args.path))}${range.length ? ` (${range.join(", ")})` : ""}`;
        return callHeader("read", detail, theme, context);
      },
      renderResult(result, { isPartial }, theme, context) {
        if (isPartial) return new Text(theme.fg("warning", "Reading..."), 0, 0);
        if (context.isError) {
          return new Text(theme.fg("error", preview(getTextContent(result) || "Read failed")), 0, 0);
        }
        const content = result.content?.[0];
        if (content?.type === "image") return new Text(theme.fg("success", "Image loaded"), 0, 0);
        const text = content?.type === "text" ? content.text ?? "" : "";
        const summary = summarizeText(text);
        const details = result.details as ReadToolDetails | undefined;
        let label = theme.fg("success", `Read ${summary.lines} lines`);
        label += theme.fg("dim", ` (${summary.bytes} bytes shown)`);
        if (details?.truncation?.truncated) {
          label += theme.fg(
            "warning",
            ` • truncated from ${details.truncation.totalLines} lines / ${details.truncation.totalBytes} bytes`,
          );
        }
        return new Text(label, 0, 0);
      },
    },
    ...(["find", "grep", "ls"] as const).map((name) => ({
      name,
      pendingLabel: name === "find" ? "Finding..." : name === "grep" ? "Searching..." : "Listing...",
      successLabel: name === "ls" ? "Listed" : "Found matches",
      renderCall: (args: any, theme: ToolTheme, context: ToolRenderContext) => {
        const value =
          name === "ls"
            ? shortenPath(args.path || ".")
            : `${name === "grep" ? `/${args.pattern}/` : args.pattern} in ${shortenPath(args.path || ".")}`;
        return callHeader(name, compactArg(value), theme, context);
      },
    })),
  ];

  for (const spec of specs) {
    const rootTool = factories[spec.name](process.cwd()) as any;
    pi.registerTool({
      ...rootTool,
      name: spec.name,
      label: spec.name,
      async execute(toolCallId, params, signal, onUpdate, ctx) {
        return (factories[spec.name](ctx.cwd) as any).execute(
          toolCallId,
          params,
          signal,
          onUpdate,
        );
      },
      renderCall: spec.renderCall,
      renderResult(result, options, theme, context) {
        if (spec.renderResult) return spec.renderResult(result, options, theme, context);
        return compactResult(
          result,
          options,
          theme,
          context,
          spec.pendingLabel,
          spec.successLabel,
        );
      },
    });
  }
}
