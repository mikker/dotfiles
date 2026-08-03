// Dotfiles-managed Pi extension.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createApplyPatchToolDefinition } from "./tool";

export default function applyPatch(pi: ExtensionAPI): void {
  pi.registerTool(createApplyPatchToolDefinition(process.cwd()));
}
