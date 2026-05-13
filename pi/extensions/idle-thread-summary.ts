import type { AgentMessage } from "@mariozechner/pi-agent-core";
import { complete, type Message } from "@mariozechner/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

const WIDGET_ID = "idle-thread-summary";
const IDLE_MS = 5 * 60 * 1000;
const MAX_CHARS = 24_000;

type TextBlock = { type?: string; text?: string; name?: string; arguments?: unknown };

function textFromContent(content: AgentMessage["content"]): string {
  if (typeof content === "string") return content.trim();
  if (!Array.isArray(content)) return "";

  return content
    .map((block) => {
      const item = block as TextBlock;
      if (item.type === "text" && typeof item.text === "string") return item.text;
      if (item.type === "toolCall" && typeof item.name === "string") {
        return `[tool ${item.name} ${JSON.stringify(item.arguments ?? {})}]`;
      }
      return "";
    })
    .filter(Boolean)
    .join("\n")
    .trim();
}

function buildThread(ctx: ExtensionContext): string {
  const chunks: string[] = [];

  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type !== "message") continue;
    const message = entry.message;
    if (message.role !== "user" && message.role !== "assistant") continue;

    const text = textFromContent(message.content);
    if (!text) continue;
    chunks.push(`${message.role === "user" ? "User" : "Assistant"}: ${text}`);
  }

  const full = chunks.join("\n\n");
  return full.length <= MAX_CHARS ? full : full.slice(-MAX_CHARS);
}

async function summarizeThread(ctx: ExtensionContext): Promise<string | null> {
  const model =
    ctx.modelRegistry.find("openai-codex", "gpt-5.4-mini") ??
    ctx.modelRegistry.find("openai-codex", "gpt-5.1-codex-mini") ??
    ctx.model;
  if (!model) return null;

  const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
  if (!auth?.ok || !auth.apiKey) return null;

  const thread = buildThread(ctx);
  if (!thread) return null;

  const messages: Message[] = [
    {
      role: "user",
      content: [
        {
          type: "text",
          text: [
            "Summarize this coding-agent thread for the user returning after a short break.",
            "Return a terse bullet list with this flow:",
            "- Overall task of the thread",
            "- Progress so far",
            "- Most recent progress and/or next step",
            "Use three bullets by default; add more only if useful.",
            "Use sentence fragments. Max 10 words per bullet.",
            "No title or preamble.",
            "",
            "<thread>",
            thread,
            "</thread>",
          ].join("\n"),
        },
      ],
      timestamp: Date.now(),
    },
  ];

  const response = await complete(model, { messages }, { apiKey: auth.apiKey, headers: auth.headers });
  const summary = response.content
    .filter((block): block is { type: "text"; text: string } => block.type === "text")
    .map((block) => block.text.trim())
    .filter(Boolean)
    .join("\n");

  return summary || null;
}

const DIM = "\x1b[2;90m";
const ACCENT = "\x1b[36m";
const BOLD = "\x1b[1m";
const RESET = "\x1b[0m";

function stripAnsi(text: string): string {
  return text.replace(/\x1b\[[0-9;]*m/g, "");
}

function wrapLine(line: string, maxWidth: number): string[] {
  const words = line.split(/\s+/).filter(Boolean);
  const lines: string[] = [];
  let current = "";

  for (const word of words) {
    const next = current ? `${current} ${word}` : word;
    if (stripAnsi(next).length > maxWidth && current) {
      lines.push(current);
      current = word;
    } else {
      current = next;
    }
  }

  if (current) lines.push(current);
  return lines.length > 0 ? lines : [""];
}

function renderSummary(summary: string): string[] {
  const maxInnerWidth = 76;
  const items = summary
    .split(/\n+/)
    .map((line) => line.replace(/^[-*•]\s*/, "").trim())
    .filter(Boolean);
  const bullets = items.length > 0 ? items : [summary.trim()];
  const contentLines = bullets.flatMap((item) => {
    const wrapped = wrapLine(item, maxInnerWidth - 2);
    return wrapped.map((line, index) => `${index === 0 ? "•" : " "} ${line}`);
  });
  const innerWidth = Math.min(
    maxInnerWidth,
    Math.max(12, ...contentLines.map((line) => stripAnsi(line).length)),
  );
  const border = "─".repeat(innerWidth + 2);

  return [
    `${DIM}┌${border}┐${RESET}`,
    ...contentLines.map((line) => {
      const padding = " ".repeat(Math.max(0, innerWidth - stripAnsi(line).length));
      return `${DIM}│${RESET} ${ACCENT}${line}${padding}${RESET} ${DIM}│${RESET}`;
    }),
    `${DIM}└${border}┘${RESET}`,
  ];
}

export default function idleThreadSummaryExtension(pi: ExtensionAPI) {
  let timer: NodeJS.Timeout | undefined;
  let generation = 0;

  function clear(ctx?: ExtensionContext) {
    generation += 1;
    if (timer) clearTimeout(timer);
    timer = undefined;
    ctx?.ui.setWidget(WIDGET_ID, undefined);
  }

  function schedule(ctx: ExtensionContext) {
    clear(ctx);
    if (!ctx.hasUI || ctx.hasPendingMessages()) return;

    const myGeneration = generation;
    timer = setTimeout(async () => {
      timer = undefined;
      if (generation !== myGeneration || !ctx.isIdle() || ctx.hasPendingMessages()) return;

      try {
        const summary = await summarizeThread(ctx);
        if (generation !== myGeneration || !summary) return;
        ctx.ui.setWidget(WIDGET_ID, renderSummary(summary));
      } catch (error) {
        if (generation === myGeneration) {
          console.error("idle-thread-summary failed", error);
        }
      }
    }, IDLE_MS);
  }

  pi.on("agent_end", async (_event, ctx) => {
    schedule(ctx);
  });

  pi.on("input", async (_event, ctx) => {
    clear(ctx);
    return { action: "continue" };
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    clear(ctx);
  });
}
