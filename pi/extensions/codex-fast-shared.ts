import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function codexFastSharedExtension(_pi: ExtensionAPI) {}

export const CODEX_FAST_ENTRY_TYPE = "codex-fast-mode";
export const CODEX_FAST_EVENT = "codex-fast:changed";
export const DEFAULT_CODEX_FAST_ENABLED = true;

const CODEX_FAST_MODELS = new Set(["gpt-5.4", "gpt-5.5"]);

export function supportsCodexFastMode(
  provider: string | undefined,
  modelId: string | undefined,
): boolean {
  return (
    provider === "openai-codex" && !!modelId && CODEX_FAST_MODELS.has(modelId)
  );
}

export function formatCodexFastLabel(
  enabled: boolean,
  provider: string | undefined,
  modelId: string | undefined,
): string {
  if (supportsCodexFastMode(provider, modelId)) {
    return enabled ? "fast" : "std";
  }
  return enabled ? "fast n/a" : "";
}
