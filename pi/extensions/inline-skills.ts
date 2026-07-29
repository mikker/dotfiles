import {
  stripFrontmatter,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import type {
  AutocompleteItem,
  AutocompleteProvider,
} from "@earendil-works/pi-tui";
import { readFile } from "node:fs/promises";
import { dirname } from "node:path";

const SKILL_COMMAND_PREFIX = "skill:";
const INLINE_SKILL_PREFIX = /(?:^|[\s([{\"'])\$([a-z0-9-]*)$/;
const INLINE_SKILL_INVOCATION = /^\s*\$([a-z0-9][a-z0-9-]*)(?:\s+([\s\S]*))?$/;
const INLINE_SKILL_PATTERN = /(^|[\s([{\"'])\$([a-z0-9][a-z0-9-]*)\b/gm;
const MAX_INLINE_SKILL_BYTES = 100 * 1024;

type SkillRef = {
  name: string;
  description?: string;
  path: string;
  baseDir: string;
};

function getSkills(pi: ExtensionAPI): SkillRef[] {
  return pi
    .getCommands()
    .filter((command) => command.source === "skill")
    .map((command) => ({
      name: command.name.slice(SKILL_COMMAND_PREFIX.length),
      description: command.description,
      path: command.sourceInfo.path,
      baseDir: command.sourceInfo.baseDir ?? dirname(command.sourceInfo.path),
    }))
    .sort((left, right) => left.name.localeCompare(right.name));
}

function findReferencedSkills(
  text: string,
  skillsByName: Map<string, SkillRef>,
): { skills: SkillRef[]; occurrenceCount: number } {
  const skills: SkillRef[] = [];
  const seen = new Set<string>();
  let occurrenceCount = 0;

  for (const match of text.matchAll(INLINE_SKILL_PATTERN)) {
    const skill = skillsByName.get(match[2]!);
    if (!skill) continue;

    occurrenceCount += 1;
    if (seen.has(skill.name)) continue;
    seen.add(skill.name);
    skills.push(skill);
  }

  return { skills, occurrenceCount };
}

async function expandInlineSkills(
  text: string,
  skills: SkillRef[],
): Promise<string> {
  const blocks: string[] = [];
  const skillNames = new Set(skills.map((skill) => skill.name));
  let totalBytes = 0;

  for (const skill of skills) {
    const content = await readFile(skill.path, "utf8");
    totalBytes += Buffer.byteLength(content, "utf8");
    if (totalBytes > MAX_INLINE_SKILL_BYTES) {
      throw new Error(
        `inline skills exceed ${MAX_INLINE_SKILL_BYTES / 1024}KB`,
      );
    }

    blocks.push(
      [
        `--- BEGIN SKILL ${skill.name} ---`,
        `Location: ${skill.path}`,
        `References are relative to ${skill.baseDir}.`,
        "",
        stripFrontmatter(content).trim(),
        `--- END SKILL ${skill.name} ---`,
      ].join("\n"),
    );
  }

  const prompt = text.replace(
    INLINE_SKILL_PATTERN,
    (full, boundary: string, name: string) =>
      skillNames.has(name) ? `${boundary}${name}` : full,
  );

  return [
    `<skill name="${skills.map((skill) => skill.name).join(", ")}" location="inline">`,
    "The user explicitly invoked the following skills. Follow them for this task.",
    "",
    blocks.join("\n\n"),
    "</skill>",
    "",
    prompt,
  ].join("\n");
}

function getPrefix(
  lines: string[],
  cursorLine: number,
  cursorCol: number,
): string | undefined {
  const beforeCursor = (lines[cursorLine] ?? "").slice(0, cursorCol);
  return beforeCursor.match(INLINE_SKILL_PREFIX)?.[1];
}

function createAutocompleteProvider(
  pi: ExtensionAPI,
  current: AutocompleteProvider,
): AutocompleteProvider {
  return {
    triggerCharacters: [
      ...new Set([...(current.triggerCharacters ?? []), "$"]),
    ],

    async getSuggestions(lines, cursorLine, cursorCol, options) {
      const prefix = getPrefix(lines, cursorLine, cursorCol);
      if (prefix === undefined) {
        return current.getSuggestions(lines, cursorLine, cursorCol, options);
      }

      const items: AutocompleteItem[] = getSkills(pi)
        .filter((skill) => skill.name.startsWith(prefix))
        .map((skill) => ({
          value: `$${skill.name} `,
          label: `$${skill.name}`,
          description: skill.description,
        }));

      return items.length > 0 ? { items, prefix: `$${prefix}` } : null;
    },

    applyCompletion(lines, cursorLine, cursorCol, item, prefix) {
      return current.applyCompletion(
        lines,
        cursorLine,
        cursorCol,
        item,
        prefix,
      );
    },

    shouldTriggerFileCompletion(lines, cursorLine, cursorCol) {
      if (getPrefix(lines, cursorLine, cursorCol) !== undefined) return false;
      return (
        current.shouldTriggerFileCompletion?.(lines, cursorLine, cursorCol) ??
        true
      );
    },
  };
}

export default function inlineSkills(pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    ctx.ui.addAutocompleteProvider((current) =>
      createAutocompleteProvider(pi, current),
    );
  });

  pi.on("input", async (event, ctx) => {
    if (event.source === "extension") return { action: "continue" };

    const skills = getSkills(pi);
    const skillsByName = new Map(skills.map((skill) => [skill.name, skill]));
    const referenced = findReferencedSkills(event.text, skillsByName);
    if (referenced.skills.length === 0) return { action: "continue" };

    const invocation = event.text.match(INLINE_SKILL_INVOCATION);
    if (invocation && referenced.occurrenceCount === 1) {
      const name = invocation[1]!;
      if (skillsByName.has(name)) {
        const prompt = invocation[2]?.trimStart();
        return {
          action: "transform",
          text: `/skill:${name}${prompt ? ` ${prompt}` : ""}`,
        };
      }
    }

    try {
      return {
        action: "transform",
        text: await expandInlineSkills(event.text, referenced.skills),
      };
    } catch (error) {
      ctx.ui.notify(
        `Could not load inline skills: ${error instanceof Error ? error.message : String(error)}`,
        "error",
      );
      return { action: "continue" };
    }
  });
}
