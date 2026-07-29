import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export const CODEX_FAST_EVENT = "codex-fast:changed";
export const DEFAULT_CODEX_FAST_ENABLED = true;

const ENTRY_TYPE = "codex-fast-mode";
const FAST_MODELS = new Set(["gpt-5.4", "gpt-5.5"]);
const FAST_MODEL_PREFIXES = ["gpt-5.6-"];
const ACTIONS = new Set(["on", "off", "toggle", "status"]);

export function supportsCodexFastMode(
  provider: string | undefined,
  modelId: string | undefined,
): boolean {
  if (!modelId) return false;

  const supportsFast =
    FAST_MODELS.has(modelId) ||
    FAST_MODEL_PREFIXES.some((prefix) => modelId.startsWith(prefix));

  return (
    (provider === "openai-codex" && supportsFast) ||
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
  entries: Array<{ type?: string; customType?: string; data?: unknown }>,
): boolean {
  let enabled = DEFAULT_CODEX_FAST_ENABLED;

  for (const entry of entries) {
    if (
      entry.type === "custom" &&
      entry.customType === ENTRY_TYPE &&
      typeof entry.data === "object" &&
      entry.data !== null &&
      typeof (entry.data as { enabled?: unknown }).enabled === "boolean"
    ) {
      enabled = (entry.data as { enabled: boolean }).enabled;
    }
  }

  return enabled;
}

export default function codexFast(pi: ExtensionAPI) {
  let enabled = DEFAULT_CODEX_FAST_ENABLED;

  const publish = () => pi.events.emit(CODEX_FAST_EVENT, { enabled });
  const setEnabled = (next: boolean, persist = false) => {
    enabled = next;
    if (persist) pi.appendEntry(ENTRY_TYPE, { enabled });
    publish();
  };

  pi.on("session_start", (_event, ctx) => {
    enabled = readFastMode(ctx.sessionManager.getEntries());
    publish();
  });

  pi.on("model_select", publish);

  pi.on("before_provider_request", (event, ctx) => {
    if (
      !enabled ||
      !supportsCodexFastMode(ctx.model?.provider, ctx.model?.id)
    ) {
      return;
    }
    if (typeof event.payload !== "object" || event.payload === null) return;

    return { ...event.payload, service_tier: "priority" };
  });

  pi.registerCommand("fast", {
    description: "Toggle Codex fast mode for this session",
    getArgumentCompletions(prefix) {
      const items = ["on", "off", "toggle", "status"]
        .filter((value) => value.startsWith(prefix))
        .map((value) => ({ value, label: value }));
      return items.length > 0 ? items : null;
    },
    handler: async (args, ctx) => {
      const action = args.trim().toLowerCase() || "toggle";
      if (!ACTIONS.has(action)) {
        ctx.ui.notify("Usage: /fast [on|off|toggle|status]", "error");
        return;
      }

      if (action === "on") setEnabled(true, true);
      if (action === "off") setEnabled(false, true);
      if (action === "toggle") setEnabled(!enabled, true);
      if (action === "status") publish();

      const supported = supportsCodexFastMode(
        ctx.model?.provider,
        ctx.model?.id,
      );
      const message = supported
        ? `Fast mode ${enabled ? "on" : "off"}.`
        : enabled
          ? "Fast mode requested, but the current model does not support it."
          : "Fast mode off.";
      ctx.ui.notify(message, "info");
    },
  });
}
