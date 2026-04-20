import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function codexFastSharedExtension(_pi: ExtensionAPI) {}

export const CODEX_FAST_ENTRY_TYPE = "codex-fast-mode";
export const CODEX_FAST_EVENT = "codex-fast:changed";
export const DEFAULT_CODEX_FAST_ENABLED = true;

export function supportsCodexFastMode(
  provider: string | undefined,
  modelId: string | undefined,
): boolean {
  return provider === "openai-codex" && modelId === "gpt-5.4";
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
