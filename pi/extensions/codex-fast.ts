import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { streamOpenAICodexResponses } from "@mariozechner/pi-ai";
import {
  CODEX_FAST_ENTRY_TYPE,
  CODEX_FAST_EVENT,
  DEFAULT_CODEX_FAST_ENABLED,
  supportsCodexFastMode,
} from "./codex-fast-shared";

function readFastMode(
  entries: Array<{
    type?: string;
    customType?: string;
    data?: { enabled?: boolean };
  }>,
): boolean {
  let enabled = DEFAULT_CODEX_FAST_ENABLED;
  for (const entry of entries) {
    if (
      entry.type !== "custom" ||
      entry.customType !== CODEX_FAST_ENTRY_TYPE ||
      typeof entry.data?.enabled !== "boolean"
    ) {
      continue;
    }
    enabled = entry.data.enabled;
  }
  return enabled;
}

export default function codexFastExtension(pi: ExtensionAPI) {
  let fastEnabled = DEFAULT_CODEX_FAST_ENABLED;

  const emitFastMode = () => {
    pi.events.emit(CODEX_FAST_EVENT, { enabled: fastEnabled });
  };

  const setFastMode = (enabled: boolean, persist = false) => {
    fastEnabled = enabled;
    if (persist) {
      pi.appendEntry(CODEX_FAST_ENTRY_TYPE, { enabled });
    }
    emitFastMode();
  };

  pi.registerProvider("openai-codex", {
    api: "openai-codex-responses",
    streamSimple(model, context, options) {
      // Codex `/fast` maps to OpenAI Responses `service_tier: "priority"`.
      return streamOpenAICodexResponses(model, context, {
        ...options,
        reasoningEffort: options?.reasoning,
        serviceTier:
          fastEnabled && supportsCodexFastMode(model.provider, model.id)
            ? "priority"
            : undefined,
      });
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    fastEnabled = readFastMode(ctx.sessionManager.getEntries());
    emitFastMode();
  });

  pi.on("session_shutdown", async () => {
    fastEnabled = DEFAULT_CODEX_FAST_ENABLED;
  });

  pi.registerCommand("fast", {
    description: "toggle Codex fast mode for this session",
    getArgumentCompletions(prefix) {
      const items = ["on", "off", "toggle", "status"].map((value) => ({
        value,
        label: value,
      }));
      const filtered = items.filter((item) => item.value.startsWith(prefix));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      const action = args.trim().toLowerCase() || "toggle";
      if (!["on", "off", "toggle", "status"].includes(action)) {
        ctx.ui.notify("Usage: /fast [on|off|toggle|status]", "error");
        return;
      }

      if (action === "on") setFastMode(true, true);
      if (action === "off") setFastMode(false, true);
      if (action === "toggle") setFastMode(!fastEnabled, true);

      if (action === "status") {
        emitFastMode();
      }

      const supported = supportsCodexFastMode(ctx.model?.provider, ctx.model?.id);
      const message = supported
        ? `Fast mode ${fastEnabled ? "on" : "off"}.`
        : fastEnabled
          ? "Fast mode requested, but the current model does not support it."
          : "Fast mode off.";
      ctx.ui.notify(message, "info");
    },
  });
}
