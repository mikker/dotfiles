import type {
  ExtensionAPI,
  ToolRenderContext,
} from "@mariozechner/pi-coding-agent";
import {
  createBashTool,
  createEditTool,
  createFindTool,
  createGrepTool,
  createLsTool,
  createWriteTool,
} from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";
import { homedir } from "node:os";

function getTextContent(result: {
  content?: Array<{ type: string; text?: string }>;
}): string {
  return result.content?.find((content) => content.type === "text")?.text ?? "";
}

function summarizeText(text: string): { lines: number; bytes: number } {
  if (!text) return { lines: 0, bytes: 0 };
  return {
    lines: text.split("\n").length,
    bytes: Buffer.byteLength(text, "utf8"),
  };
}

function compactResult(
  result: { content?: Array<{ type: string; text?: string }> },
  options: { expanded?: boolean; isPartial?: boolean },
  theme: any,
  pendingLabel: string,
  successLabel: string,
) {
  if (options.isPartial)
    return new Text(theme.fg("warning", pendingLabel), 0, 0);

  const text = getTextContent(result);
  if (!options.expanded) {
    if (text.startsWith("Error"))
      return new Text(theme.fg("error", text.split("\n")[0] || "Error"), 0, 0);
    return new Text("", 0, 0);
  }

  if (!text) return new Text(theme.fg("success", successLabel), 0, 0);
  if (text.startsWith("Error")) return new Text(theme.fg("error", text), 0, 0);

  const summary = summarizeText(text);
  let output = theme.fg("success", successLabel);
  if (summary.lines > 0 || summary.bytes > 0) {
    output += theme.fg(
      "dim",
      ` (${summary.lines} lines, ${summary.bytes} bytes)`,
    );
  }
  output += `\n${theme.fg("toolOutput", text)}`;
  return new Text(output, 0, 0);
}

function shortenPath(path: string): string {
  const home = homedir();
  return path.startsWith(home) ? `~${path.slice(home.length)}` : path;
}

function renderStatusDot(theme: any, context: ToolRenderContext): string {
  if (context.isError) return theme.fg("error", "●");
  if (context.executionStarted && !context.isPartial)
    return theme.fg("success", "●");
  return theme.fg("warning", "●");
}

const toolCache = new Map<string, ReturnType<typeof createBuiltInTools>>();
const rootTools = createBuiltInTools(process.cwd());

type BuiltInTools = ReturnType<typeof createBuiltInTools>;
type BuiltInToolName = keyof BuiltInTools;

type ToolSpec<TName extends BuiltInToolName> = {
  name: TName;
  pendingLabel: string;
  successLabel: string;
  renderCall: (args: any, theme: any, context: ToolRenderContext) => Text;
};

function createBuiltInTools(cwd: string) {
  return {
    bash: createBashTool(cwd),
    edit: createEditTool(cwd),
    write: createWriteTool(cwd),
    find: createFindTool(cwd),
    grep: createGrepTool(cwd),
    ls: createLsTool(cwd),
  };
}

function getBuiltInTools(cwd: string) {
  let tools = toolCache.get(cwd);
  if (!tools) {
    tools = createBuiltInTools(cwd);
    toolCache.set(cwd, tools);
  }
  return tools;
}

export default function toolCallDotsExtension(pi: ExtensionAPI) {
  const specs: ToolSpec<BuiltInToolName>[] = [
    {
      name: "bash",
      pendingLabel: "Running...",
      successLabel: "Done",
      renderCall(args, theme, context) {
        let text = `${renderStatusDot(theme, context)} `;
        text += theme.fg("toolTitle", theme.bold("bash "));
        text += theme.fg("accent", args.command);
        if (args.timeout)
          text += theme.fg("dim", ` (timeout ${args.timeout}s)`);
        return new Text(text, 0, 0);
      },
    },
    {
      name: "edit",
      pendingLabel: "Editing...",
      successLabel: "Applied",
      renderCall(args, theme, context) {
        let text = `${renderStatusDot(theme, context)} `;
        text += theme.fg("toolTitle", theme.bold("edit "));
        text += theme.fg("accent", shortenPath(args.path));
        return new Text(text, 0, 0);
      },
    },
    {
      name: "write",
      pendingLabel: "Writing...",
      successLabel: "Written",
      renderCall(args, theme, context) {
        let text = `${renderStatusDot(theme, context)} `;
        text += theme.fg("toolTitle", theme.bold("write "));
        text += theme.fg("accent", shortenPath(args.path));
        return new Text(text, 0, 0);
      },
    },
    {
      name: "find",
      pendingLabel: "Finding...",
      successLabel: "Found matches",
      renderCall(args, theme, context) {
        let text = `${renderStatusDot(theme, context)} `;
        text += theme.fg("toolTitle", theme.bold("find "));
        text += theme.fg("accent", args.pattern);
        text += theme.fg("dim", ` in ${shortenPath(args.path || ".")}`);
        return new Text(text, 0, 0);
      },
    },
    {
      name: "grep",
      pendingLabel: "Searching...",
      successLabel: "Found matches",
      renderCall(args, theme, context) {
        let text = `${renderStatusDot(theme, context)} `;
        text += theme.fg("toolTitle", theme.bold("grep "));
        text += theme.fg("accent", `/${args.pattern}/`);
        text += theme.fg("dim", ` in ${shortenPath(args.path || ".")}`);
        return new Text(text, 0, 0);
      },
    },
    {
      name: "ls",
      pendingLabel: "Listing...",
      successLabel: "Listed",
      renderCall(args, theme, context) {
        let text = `${renderStatusDot(theme, context)} `;
        text += theme.fg("toolTitle", theme.bold("ls "));
        text += theme.fg("accent", shortenPath(args.path || "."));
        return new Text(text, 0, 0);
      },
    },
  ];

  for (const spec of specs) {
    const rootTool = rootTools[spec.name];
    pi.registerTool({
      name: spec.name,
      label: spec.name,
      description: rootTool.description,
      parameters: rootTool.parameters,
      async execute(toolCallId, params, signal, onUpdate, ctx) {
        return getBuiltInTools(ctx.cwd)[spec.name].execute(
          toolCallId,
          params,
          signal,
          onUpdate,
        );
      },
      renderCall: spec.renderCall,
      renderResult(result, options, theme) {
        return compactResult(
          result,
          options,
          theme,
          spec.pendingLabel,
          spec.successLabel,
        );
      },
    });
  }
}
