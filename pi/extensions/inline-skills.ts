import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { readFileSync } from "node:fs";

type SkillRef = {
	name: string;
	commandName: string;
	description?: string;
	path: string;
};

const INLINE_SKILL_PATTERN_GLOBAL = /(^|[\s([{"'])([$#])([a-z0-9][a-z0-9-]*)\b/gm;
const SKILL_COMMAND_PREFIX = "skill:";

function normalizeSkillName(commandName: string): string | null {
	if (!commandName.startsWith(SKILL_COMMAND_PREFIX)) return null;
	return commandName.slice(SKILL_COMMAND_PREFIX.length);
}

function loadSkillText(skill: SkillRef): string {
	return readFileSync(skill.path, "utf8").trim();
}

function replaceInlineSkillTokens(text: string, skillsByName: Map<string, SkillRef>): string {
	return text.replace(INLINE_SKILL_PATTERN_GLOBAL, (full, prefix: string, _trigger: string, name: string) => {
		if (!skillsByName.has(name)) return full;
		return `${prefix}${name}`;
	});
}

function injectInlineSkills(text: string, skills: SkillRef[]): string {
	if (skills.length === 0) return text;

	const skillsByName = new Map(skills.map((skill) => [skill.name, skill]));
	const rewrittenPrompt = replaceInlineSkillTokens(text, skillsByName);
	const skillBlocks = skills
		.map((skill) => {
			const content = loadSkillText(skill);
			return [
				`--- BEGIN INLINE SKILL ${skill.name} ---`,
				content,
				`--- END INLINE SKILL ${skill.name} ---`,
			].join("\n");
		})
		.join("\n\n");

	return [
		"The user referenced inline skills. Load and follow them for this task.",
		"",
		skillBlocks,
		"",
		"--- USER PROMPT ---",
		rewrittenPrompt,
	].join("\n");
}

export default function inlineSkillsExtension(pi: ExtensionAPI) {
	const getSkills = (): SkillRef[] =>
		pi
			.getCommands()
			.filter((command) => command.source === "skill")
			.map((command) => {
				const name = normalizeSkillName(command.name);
				if (!name) return null;
				return {
					name,
					commandName: command.name,
					description: command.description,
					path: command.sourceInfo.path,
				} satisfies SkillRef;
			})
			.filter((skill): skill is SkillRef => skill !== null)
			.sort((a, b) => a.name.localeCompare(b.name));

	const getSkillMap = () => new Map(getSkills().map((skill) => [skill.name, skill]));

	pi.on("input", (event) => {
		if (event.source === "extension") return { action: "continue" };

		const matches = [...event.text.matchAll(INLINE_SKILL_PATTERN_GLOBAL)];
		if (matches.length === 0) return { action: "continue" };

		const skillMap = getSkillMap();
		const uniqueSkills: SkillRef[] = [];
		const seen = new Set<string>();

		for (const match of matches) {
			const name = match[3];
			const skill = skillMap.get(name);
			if (!skill || seen.has(name)) continue;
			seen.add(name);
			uniqueSkills.push(skill);
		}

		if (uniqueSkills.length === 0) return { action: "continue" };

		return {
			action: "transform",
			text: injectInlineSkills(event.text, uniqueSkills),
		};
	});

	pi.registerCommand("skills-inline", {
		description: "List inline skill triggers",
		getArgumentCompletions(prefix) {
			const items = getSkills().map((skill) => ({
				value: skill.name,
				label: `$${skill.name}`,
				description: skill.description,
			}));
			const filtered = items.filter((item) => item.value.startsWith(prefix));
			return filtered.length > 0 ? filtered : null;
		},
		handler: async (args, ctx) => {
			const skills = getSkills().filter((skill) => !args.trim() || skill.name.startsWith(args.trim()));
			if (skills.length === 0) {
				ctx.ui.notify("No inline skills found", "info");
				return;
			}
			const choice = await ctx.ui.select(
				"Inline skills",
				skills.map((skill) => `$${skill.name}${skill.description ? ` — ${skill.description}` : ""}`),
			);
			if (!choice) return;
			const token = choice.split(" — ")[0] ?? choice;
			ctx.ui.pasteToEditor(token);
		},
	});
}
