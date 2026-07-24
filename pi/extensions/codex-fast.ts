import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
  streamOpenAICodexResponses,
  streamOpenAIResponses,
} from "@earendil-works/pi-ai";
export const CODEX_FAST_ENTRY_TYPE = "codex-fast-mode";
export const CODEX_FAST_EVENT = "codex-fast:changed";
export const DEFAULT_CODEX_FAST_ENABLED = true;

const CODEX_FAST_MODELS = new Set(["gpt-5.4", "gpt-5.5"]);
const CODEX_FAST_MODEL_FAMILIES = ["gpt-5.6-"];

export function supportsCodexFastMode(
  provider: string | undefined,
  modelId: string | undefined,
): boolean {
  if (!modelId) return false;

  const isFastModel =
    CODEX_FAST_MODELS.has(modelId) ||
    CODEX_FAST_MODEL_FAMILIES.some((prefix) => modelId.startsWith(prefix));

  return (
    (provider === "openai-codex" && isFastModel) ||
    (provider === "openai" && modelId.startsWith("gpt-5.6-"))
  );
}

export function formatCodexFastLabel(
  enabled: boolean,
  provider: string | undefined,
  modelId: string | undefined,
): string {
  if (supportsCodexFastMode(provider, modelId)) return enabled ? "fast" : "std";
  return enabled ? "fast n/a" : "";
}

function readFastMode(
  entries: Array<{
    type?: string;
    customType?: string;
    data?: unknown;
  }>,
): boolean {
  let enabled = DEFAULT_CODEX_FAST_ENABLED;
  for (const entry of entries) {
    if (
      entry.type !== "custom" ||
      entry.customType !== CODEX_FAST_ENTRY_TYPE ||
      !entry.data ||
      typeof entry.data !== "object" ||
      typeof (entry.data as { enabled?: unknown }).enabled !== "boolean"
    ) {
      continue;
    }
    enabled = (entry.data as { enabled: boolean }).enabled;
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

  const serviceTierFor = (provider: string, modelId: string) =>
    fastEnabled && supportsCodexFastMode(provider, modelId)
      ? "priority"
      : undefined;

  pi.registerProvider("openai-codex", {
    api: "openai-codex-responses",
    streamSimple(model, context, options) {
      // Codex `/fast` maps to OpenAI Responses `service_tier: "priority"`.
      return streamOpenAICodexResponses(
        model as Parameters<typeof streamOpenAICodexResponses>[0],
        context,
        {
        ...options,
        reasoningEffort: options?.reasoning,
        serviceTier: serviceTierFor(model.provider, model.id),
      });
    },
  });

  pi.registerProvider("openai", {
    api: "openai-responses",
    streamSimple(model, context, options) {
      return streamOpenAIResponses(
        model as Parameters<typeof streamOpenAIResponses>[0],
        context,
        {
        ...options,
        reasoningEffort: options?.reasoning,
        serviceTier: serviceTierFor(model.provider, model.id),
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

      const supported = supportsCodexFastMode(
        ctx.model?.provider,
        ctx.model?.id,
      );
      const message = supported
        ? `Fast mode ${fastEnabled ? "on" : "off"}.`
        : fastEnabled
        ? "Fast mode requested, but the current model does not support it."
        : "Fast mode off.";
      ctx.ui.notify(message, "info");
    },
  });
}
