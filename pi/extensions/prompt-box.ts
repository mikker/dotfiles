import type { AgentMessage } from "@mariozechner/pi-agent-core";
import { complete, type Message } from "@mariozechner/pi-ai";
import { CustomEditor, type ExtensionAPI, type ExtensionContext } from "@mariozechner/pi-coding-agent";
import { basename } from "node:path";
import {
  CombinedAutocompleteProvider,
  matchesKey,
  truncateToWidth,
  visibleWidth,
  type AutocompleteItem,
  type AutocompleteProvider,
  type AutocompleteSuggestions,
  type EditorTheme,
  type KeybindingsManager,
  type TUI,
} from "@mariozechner/pi-tui";

const ANSI_REGEX = /\x1b\[[0-9;]*m/g;
const SUBTLE_BORDER = (text: string) => `\x1b[38;5;240m${text}\x1b[0m`;
const SUBTLE_TITLE = (text: string) => `\x1b[38;5;245m${text}\x1b[0m`;
const SUBTLE_BADGE = (text: string) => `\x1b[38;5;243m${text}\x1b[0m`;
const TITLE_GLYPH = " ";
const DEFAULT_STATUS = "You're doing great";
const BADGES = {
  ready: "◦ ready",
  thinking: "✦ thinking",
} as const;
const INLINE_SKILL_PATTERN = /(^|[\s([{"'])([$#])([a-z0-9][a-z0-9-]*)$/;
const SKILL_COMMAND_PREFIX = "skill:";

type SkillRef = {
  name: string;
  description?: string;
};

type GitMeta = {
  branch: string;
  status: string;
};

type TextBlock = {
  type?: string;
  text?: string;
};

function formatThinkingLevel(level: ReturnType<ExtensionAPI["getThinkingLevel"]>): string {
  switch (level) {
    case "off":
      return "◌ off";
    case "minimal":
      return "◔ min";
    case "low":
      return "◑ low";
    case "medium":
      return "◕ med";
    case "high":
      return "● high";
    case "xhigh":
      return "✹ max";
  }
}

function stripAnsi(text: string): string {
  return text.replace(ANSI_REGEX, "");
}

function padLine(text: string, width: number): string {
  const truncated = truncateToWidth(text, width, "");
  return truncated + " ".repeat(Math.max(0, width - visibleWidth(truncated)));
}

function looksLikeEditorRule(line: string): boolean {
  const plain = stripAnsi(line).trim();
  return plain.startsWith("─");
}

function extractInlineMatch(lineBeforeCursor: string): { trigger: "$" | "#"; prefix: string } | null {
  const match = lineBeforeCursor.match(INLINE_SKILL_PATTERN);
  if (!match) return null;
  const trigger = match[2];
  const prefix = match[3];
  if (trigger !== "$" && trigger !== "#") return null;
  return { trigger, prefix };
}

function normalizeSkillName(commandName: string): string | null {
  if (!commandName.startsWith(SKILL_COMMAND_PREFIX)) return null;
  return commandName.slice(SKILL_COMMAND_PREFIX.length);
}

function formatTaskSummary(summary: string): string {
  const compact = summary.replace(/\s+/g, " ").trim();
  if (!compact || compact === DEFAULT_STATUS) return "";
  return truncateToWidth(compact, 28, "…");
}

function extractMessageText(message: AgentMessage): string {
  const { content } = message;
  if (typeof content === "string") return content.trim();
  if (!Array.isArray(content)) return "";
  return content
    .filter((block): block is TextBlock => !!block && typeof block === "object")
    .filter((block) => block.type === "text" && typeof block.text === "string")
    .map((block) => block.text!.trim())
    .filter(Boolean)
    .join("\n");
}

function buildSummaryContext(ctx: ExtensionContext): string {
  const messages: AgentMessage[] = [];
  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type !== "message") continue;
    const message = entry.message;
    if (message.role !== "user" && message.role !== "assistant") continue;
    messages.push(message);
  }

  return messages
    .slice(-6)
    .map((message) => {
      const text = extractMessageText(message);
      if (!text) return "";
      const role = message.role === "user" ? "User" : "Assistant";
      return `${role}: ${text}`;
    })
    .filter(Boolean)
    .join("\n\n");
}

async function generateTaskSummary(ctx: ExtensionContext): Promise<string | null> {
  const preferredModel =
    ctx.modelRegistry.find("openai-codex", "gpt-5.4-mini")
    ?? ctx.modelRegistry.find("openai-codex", "gpt-5.1-codex-mini")
    ?? ctx.model;
  if (!preferredModel) return null;

  const auth = await ctx.modelRegistry.getApiKeyAndHeaders(preferredModel);
  if (!auth?.ok || !auth.apiKey) return null;

  const conversation = buildSummaryContext(ctx);
  if (!conversation) return null;

  const messages: Message[] = [{
    role: "user",
    content: [{
      type: "text",
      text: [
        "Generate a very short coding task label for this session.",
        "Return only the label.",
        "Rules: 2-6 words, lowercase, concrete, no punctuation, no quotes.",
        "Prefer active work like fix auth redirect or refactor prompt box.",
        "",
        conversation,
      ].join("\n"),
    }],
    timestamp: Date.now(),
  }];

  const response = await complete(preferredModel, { messages }, { apiKey: auth.apiKey, headers: auth.headers });
  const summary = response.content
    .filter((block): block is { type: "text"; text: string } => block.type === "text")
    .map((block) => block.text)
    .join(" ")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase()
    .replace(/^["'`]+|["'`]+$/g, "");

  return summary ? truncateToWidth(summary, 28, "…") : null;
}

async function getGitMeta(pi: ExtensionAPI, cwd: string): Promise<GitMeta | null> {
  const [branchResult, statusResult] = await Promise.all([
    pi.exec("git", ["-C", cwd, "branch", "--show-current"]),
    pi.exec("git", ["-C", cwd, "status", "--porcelain"]),
  ]);
  if (branchResult.code !== 0 || statusResult.code !== 0) return null;

  const branch = (branchResult.stdout ?? "").trim() || "detached";
  let staged = 0;
  let unstaged = 0;
  for (const line of (statusResult.stdout ?? "").split("\n")) {
    if (!line) continue;
    if ((line[0] ?? " ") !== " ") staged += 1;
    if ((line[1] ?? " ") !== " ") unstaged += 1;
  }
  const status = staged === 0 && unstaged === 0 ? "clean" : `+${staged}/-${unstaged}`;
  return { branch, status };
}

class InlineSkillAutocompleteProvider implements AutocompleteProvider {
  constructor(
    private readonly getSkills: () => SkillRef[],
    private readonly fallback: AutocompleteProvider,
  ) { }

  async getSuggestions(
    lines: string[],
    cursorLine: number,
    cursorCol: number,
    options: { signal: AbortSignal; force?: boolean },
  ): Promise<AutocompleteSuggestions | null> {
    const currentLine = lines[cursorLine] ?? "";
    const beforeCursor = currentLine.slice(0, cursorCol);
    const inlineMatch = extractInlineMatch(beforeCursor);

    if (!inlineMatch) {
      return this.fallback.getSuggestions(lines, cursorLine, cursorCol, options);
    }

    const items: AutocompleteItem[] = this.getSkills()
      .filter((skill) => skill.name.startsWith(inlineMatch.prefix))
      .map((skill) => ({
        value: skill.name,
        label: `${inlineMatch.trigger}${skill.name}`,
        description: skill.description,
      }));

    if (items.length === 0) return null;
    return {
      items,
      prefix: `${inlineMatch.trigger}${inlineMatch.prefix}`,
    };
  }

  applyCompletion(lines: string[], cursorLine: number, cursorCol: number, item: AutocompleteItem, prefix: string) {
    if (!prefix.startsWith("$") && !prefix.startsWith("#")) {
      return this.fallback.applyCompletion(lines, cursorLine, cursorCol, item, prefix);
    }

    const line = lines[cursorLine] ?? "";
    const beforeCursor = line.slice(0, cursorCol);
    const afterCursor = line.slice(cursorCol);
    const replacement = `${prefix[0]}${item.value}`;
    const nextBeforeCursor = beforeCursor.slice(0, Math.max(0, beforeCursor.length - prefix.length)) + replacement;
    const nextLines = [...lines];
    nextLines[cursorLine] = `${nextBeforeCursor}${afterCursor}`;

    return {
      lines: nextLines,
      cursorLine,
      cursorCol: nextBeforeCursor.length,
    };
  }
}

class PromptBoxEditor extends CustomEditor {
  private readonly title: () => string;
  private readonly summary: () => string;
  private readonly badge: () => string;
  private readonly model: () => string;
  private readonly thinking: () => string;
  private readonly theme: EditorTheme;
  private readonly getSkillsRef: () => SkillRef[];

  constructor(
    tui: TUI,
    theme: EditorTheme,
    keybindings: KeybindingsManager,
    title: () => string,
    summary: () => string,
    badge: () => string,
    model: () => string,
    thinking: () => string,
    getSkills: () => SkillRef[],
    getCommands: () => Array<{ name: string; description?: string }>,
    basePath: string,
  ) {
    super(tui, theme, keybindings, { paddingX: 1, autocompleteMaxVisible: 6 });
    this.title = title;
    this.summary = summary;
    this.badge = badge;
    this.model = model;
    this.thinking = thinking;
    this.theme = theme;
    this.getSkillsRef = getSkills;
    const fallback = new CombinedAutocompleteProvider(getCommands(), basePath);
    this.setAutocompleteProvider(new InlineSkillAutocompleteProvider(getSkills, fallback));
  }

  refresh(): void {
    this.tui.requestRender();
  }

  private getInlineContext(): { trigger: "$" | "#"; prefix: string; matches: SkillRef[] } | null {
    const cursor = this.getCursor();
    const line = this.getLines()[cursor.line] ?? "";
    const beforeCursor = line.slice(0, cursor.col);
    const match = extractInlineMatch(beforeCursor);
    if (!match) return null;
    const matches = this.getSkillsRef().filter((skill) => skill.name.startsWith(match.prefix));
    if (matches.length === 0) return null;
    return { ...match, matches };
  }

  private getCommonNamePrefix(matches: SkillRef[]): string {
    const [first, ...rest] = matches.map((match) => match.name);
    if (!first) return "";
    let prefix = first;
    for (const name of rest) {
      while (!name.startsWith(prefix) && prefix.length > 0) prefix = prefix.slice(0, -1);
    }
    return prefix;
  }

  override handleInput(data: string): void {
    if (matchesKey(data, "tab")) {
      const context = this.getInlineContext();
      if (context) {
        const completionName =
          context.matches.length === 1 ? context.matches[0]!.name : this.getCommonNamePrefix(context.matches);
        const current = `${context.trigger}${context.prefix}`;
        const target = `${context.trigger}${completionName}`;
        if (target.startsWith(current) && target.length > current.length) {
          this.insertTextAtCursor(target.slice(current.length));
          return;
        }
      }
    }

    super.handleInput(data);
  }

  render(width: number): string[] {
    if (width < 12) return super.render(width);

    const innerWidth = width - 4;
    const rendered = super.render(innerWidth);
    if (rendered.length < 2) return rendered;

    const closingRuleIndex = (() => {
      for (let i = rendered.length - 1; i > 0; i--) {
        if (looksLikeEditorRule(rendered[i]!)) return i;
      }
      return rendered.length - 1;
    })();

    const bodyLines = rendered.slice(1, closingRuleIndex);
    const autocompleteLines = rendered.slice(closingRuleIndex + 1);
    const inlineContext = this.getInlineContext();
    const inlineSuggestions = inlineContext
      ? inlineContext.matches.slice(0, 5).map((skill, index) => {
        const prefix = index === 0 ? "→ " : "  ";
        const text = `${prefix}${inlineContext.trigger}${skill.name}${skill.description ? ` — ${skill.description}` : ""}`;
        return truncateToWidth(this.theme.selectList.description(text), Math.max(1, innerWidth));
      })
      : [];

    const leftTitle = ` ${TITLE_GLYPH} ${this.title().trim() || DEFAULT_STATUS} `;
    const summary = this.summary().trim();
    const badge = this.badge().trim();
    const model = this.model().trim();
    const thinking = this.thinking().trim();
    const rightMeta = [summary, badge, model, thinking].filter(Boolean).join("  ");
    const maxLeftWidth = Math.max(0, width - 8 - (rightMeta ? visibleWidth(` ${rightMeta} `) : 0));
    const titleText = truncateToWidth(leftTitle, maxLeftWidth, "");
    const badgeText = rightMeta ? ` ${truncateToWidth(rightMeta, Math.max(0, width - visibleWidth(titleText) - 4), "")} ` : "";
    const topFill = Math.max(0, width - visibleWidth(titleText) - visibleWidth(badgeText) - 2);
    const top = `${SUBTLE_BORDER("╭")}${SUBTLE_TITLE(titleText)}${SUBTLE_BORDER("─".repeat(topFill))}${badgeText ? SUBTLE_BADGE(badgeText) : ""}${SUBTLE_BORDER("╮")}`;
    const separator = SUBTLE_BORDER(`├${"─".repeat(width - 2)}┤`);
    const bottom = SUBTLE_BORDER(`╰${"─".repeat(width - 2)}╯`);

    const boxedBody = (bodyLines.length > 0 ? bodyLines : [""]).map(
      (line) => `${SUBTLE_BORDER("│")} ${padLine(line, innerWidth)} ${SUBTLE_BORDER("│")}`,
    );
    const boxedInlineSuggestions = inlineSuggestions.map(
      (line) => `${SUBTLE_BORDER("│")} ${padLine(line, innerWidth)} ${SUBTLE_BORDER("│")}`,
    );
    const boxedAutocomplete = autocompleteLines.map(
      (line) => `${SUBTLE_BORDER("│")} ${padLine(line, innerWidth)} ${SUBTLE_BORDER("│")}`,
    );

    const lines = [top, ...boxedBody];
    if (boxedInlineSuggestions.length > 0) lines.push(separator, ...boxedInlineSuggestions);
    if (boxedAutocomplete.length > 0) lines.push(separator, ...boxedAutocomplete);
    lines.push(bottom);
    return lines;
  }
}

export default function promptBoxExtension(pi: ExtensionAPI) {
  let currentStatus = DEFAULT_STATUS;
  let currentBadge = BADGES.ready;
  let currentModel = "";
  let currentTitle = DEFAULT_STATUS;
  let editor: PromptBoxEditor | undefined;
  let currentCwd: string | undefined;
  let gitMeta: GitMeta | null = null;
  let lastSummarizedLeafId: string | undefined;
  let summaryRun = 0;

  const setStatus = (status: string) => {
    currentStatus = status.trim() || DEFAULT_STATUS;
    editor?.refresh();
  };

  const setBadge = (badge: string) => {
    currentBadge = badge;
    editor?.refresh();
  };

  const setModel = (model: string | undefined) => {
    currentModel = model?.trim() ?? "";
    editor?.refresh();
  };

  const refreshTitle = () => {
    const parts = [currentCwd ? basename(currentCwd) : undefined, gitMeta?.branch, gitMeta?.status].filter(Boolean);
    currentTitle = parts.join(" · ") || DEFAULT_STATUS;
    editor?.refresh();
  };

  const refreshGitMeta = async () => {
    if (!currentCwd) return;
    gitMeta = await getGitMeta(pi, currentCwd);
    refreshTitle();
  };

  const getSkills = (): SkillRef[] =>
    pi
      .getCommands()
      .filter((command) => command.source === "skill")
      .map((command) => {
        const name = normalizeSkillName(command.name);
        if (!name) return null;
        return {
          name,
          description: command.description,
        } satisfies SkillRef;
      })
      .filter((skill): skill is SkillRef => skill !== null)
      .sort((a, b) => a.name.localeCompare(b.name));

  const getCommands = () =>
    pi.getCommands().map((command) => ({
      name: command.name,
      description: command.description,
    }));

  pi.on("session_start", (_event, ctx) => {
    currentCwd = ctx.cwd;
    gitMeta = null;
    setStatus(pi.getSessionName() ?? DEFAULT_STATUS);
    setModel(ctx.model?.id);
    refreshTitle();
    void refreshGitMeta();
    ctx.ui.setEditorComponent((tui, theme, keybindings) => {
      editor = new PromptBoxEditor(
        tui,
        theme,
        keybindings,
        () => currentTitle,
        () => formatTaskSummary(currentStatus),
        () => currentBadge,
        () => currentModel,
        () => formatThinkingLevel(pi.getThinkingLevel()),
        getSkills,
        getCommands,
        ctx.cwd,
      );
      return editor;
    });
  });

  pi.on("agent_start", async (_event, ctx) => {
    setBadge(BADGES.thinking);
    setModel(ctx.model?.id);
  });

  pi.on("agent_end", async (_event, ctx) => {
    setBadge(BADGES.ready);
    void refreshGitMeta();

    const leafId = ctx.sessionManager.getLeafId();
    if (!leafId || leafId === lastSummarizedLeafId) {
      setStatus(pi.getSessionName() ?? DEFAULT_STATUS);
      return;
    }

    const runId = ++summaryRun;
    try {
      const summary = await generateTaskSummary(ctx);
      if (runId !== summaryRun || !summary) {
        setStatus(pi.getSessionName() ?? DEFAULT_STATUS);
        return;
      }
      lastSummarizedLeafId = leafId;
      pi.setSessionName(summary);
      setStatus(summary);
    }
    catch {
      setStatus(pi.getSessionName() ?? DEFAULT_STATUS);
    }
  });

  pi.on("model_select", async (event) => {
    setModel(event.model.id);
  });

  pi.on("session_shutdown", async () => {
    setStatus(DEFAULT_STATUS);
    currentCwd = undefined;
    gitMeta = null;
    currentModel = "";
    currentTitle = DEFAULT_STATUS;
    editor = undefined;
  });
}
