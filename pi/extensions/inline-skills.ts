import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFile } from "node:fs/promises";

type SkillRef = {
  name: string;
  description: string | undefined;
  path: string;
};

const INLINE_SKILL_PATTERN_GLOBAL =
  /(^|[\s([{"'])([$#])([a-z0-9][a-z0-9-]*)\b/gm;
const SKILL_COMMAND_PREFIX = "skill:";
const MAX_INLINE_SKILL_BYTES = 100 * 1024;

function normalizeSkillName(commandName: string): string | null {
  if (!commandName.startsWith(SKILL_COMMAND_PREFIX)) return null;
  return commandName.slice(SKILL_COMMAND_PREFIX.length);
}

function replaceInlineSkillTokens(
  text: string,
  skillsByName: Map<string, SkillRef>,
): string {
  return text.replace(
    INLINE_SKILL_PATTERN_GLOBAL,
    (full, prefix: string, _trigger: string, name: string) => {
      if (!skillsByName.has(name)) return full;
      return `${prefix}${name}`;
    },
  );
}

async function injectInlineSkills(text: string, skills: SkillRef[]): Promise<string> {
  if (skills.length === 0) return text;

  const skillsByName = new Map(skills.map((skill) => [skill.name, skill]));
  const rewrittenPrompt = replaceInlineSkillTokens(text, skillsByName);
  const blocks: string[] = [];
  let totalBytes = 0;

  for (const skill of skills) {
    const content = (await readFile(skill.path, "utf8")).trim();
    totalBytes += Buffer.byteLength(content, "utf8");
    if (totalBytes > MAX_INLINE_SKILL_BYTES) {
      throw new Error(`Inline skills exceed ${MAX_INLINE_SKILL_BYTES / 1024}KB`);
    }
    blocks.push([
      `--- BEGIN INLINE SKILL ${skill.name} ---`,
      content,
      `--- END INLINE SKILL ${skill.name} ---`,
    ].join("\n"));
  }
  const skillBlocks = blocks.join("\n\n");

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
          description: command.description,
          path: command.sourceInfo.path,
        } satisfies SkillRef;
      })
      .filter((skill): skill is SkillRef => skill !== null)
      .sort((a, b) => a.name.localeCompare(b.name));

  pi.on("input", async (event, ctx) => {
    if (event.source === "extension") return { action: "continue" };

    const matches = [...event.text.matchAll(INLINE_SKILL_PATTERN_GLOBAL)];
    if (matches.length === 0) return { action: "continue" };

    const skillMap = new Map(getSkills().map((skill) => [skill.name, skill]));
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

    try {
      return {
        action: "transform",
        text: await injectInlineSkills(event.text, uniqueSkills),
      };
    } catch (error) {
      ctx.ui.notify(
        `Could not load inline skills: ${error instanceof Error ? error.message : String(error)}`,
        "error",
      );
      return { action: "continue" };
    }
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
      const prefix = args.trim();
      const skills = getSkills().filter(
        (skill) => !prefix || skill.name.startsWith(prefix),
      );
      if (skills.length === 0) {
        ctx.ui.notify("No inline skills found", "info");
        return;
      }
      const choice = await ctx.ui.select(
        "Inline skills",
        skills.map(
          (skill) =>
            `$${skill.name}${
              skill.description ? ` — ${skill.description}` : ""
            }`,
        ),
      );
      if (!choice) return;
      const token = choice.split(" — ")[0] ?? choice;
      ctx.ui.pasteToEditor(token);
    },
  });
}
