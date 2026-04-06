import { CustomEditor, type ExtensionAPI } from "@mariozechner/pi-coding-agent";
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
const TITLE_GLYPH = "󰧑";
const DEFAULT_STATUS = "prompt";
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

class InlineSkillAutocompleteProvider implements AutocompleteProvider {
	constructor(
		private readonly getSkills: () => SkillRef[],
		private readonly fallback: AutocompleteProvider,
	) {}

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
	private readonly status: () => string;
	private readonly badge: () => string;
	private readonly thinking: () => string;
	private readonly theme: EditorTheme;
	private readonly getSkillsRef: () => SkillRef[];

	constructor(
		tui: TUI,
		theme: EditorTheme,
		keybindings: KeybindingsManager,
		status: () => string,
		badge: () => string,
		thinking: () => string,
		getSkills: () => SkillRef[],
		getCommands: () => Array<{ name: string; description?: string }>,
		basePath: string,
	) {
		super(tui, theme, keybindings, { paddingX: 1, autocompleteMaxVisible: 6 });
		this.status = status;
		this.badge = badge;
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

		const leftTitle = ` ${TITLE_GLYPH} ${this.status().trim() || DEFAULT_STATUS} `;
		const badge = this.badge().trim();
		const thinking = this.thinking().trim();
		const rightMeta = [badge, thinking].filter(Boolean).join("  ");
		const maxLeftWidth = Math.max(0, width - 8 - (rightMeta ? visibleWidth(` ${rightMeta} `) : 0));
		const titleText = truncateToWidth(leftTitle, maxLeftWidth, "");
		const badgeText = rightMeta ? ` ${rightMeta} ` : "";
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
	let editor: PromptBoxEditor | undefined;

	const setStatus = (status: string) => {
		currentStatus = status.trim() || DEFAULT_STATUS;
		editor?.refresh();
	};

	const setBadge = (badge: string) => {
		currentBadge = badge;
		editor?.refresh();
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
		setStatus(DEFAULT_STATUS);
		ctx.ui.setEditorComponent((tui, theme, keybindings) => {
			editor = new PromptBoxEditor(
				tui,
				theme,
				keybindings,
				() => currentStatus,
				() => currentBadge,
				() => formatThinkingLevel(pi.getThinkingLevel()),
				getSkills,
				getCommands,
				ctx.cwd,
			);
			return editor;
		});
	});

	pi.on("agent_start", async () => {
		setBadge(BADGES.thinking);
	});

	pi.on("agent_end", async () => {
		setBadge(BADGES.ready);
	});

	pi.events.on("worktables:status", (data) => {
		const status = typeof data === "object" && data && "detail" in data ? String((data as { detail?: string }).detail ?? "") : "";
		setStatus(status);
	});

	pi.on("session_shutdown", async () => {
		setStatus(DEFAULT_STATUS);
		editor = undefined;
	});
}
