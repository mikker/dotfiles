import { homedir } from "node:os";
import { relative } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
  ReadonlyFooterDataProvider,
  Theme,
} from "@earendil-works/pi-coding-agent";
import {
  getCapabilities,
  hyperlink,
  truncateToWidth,
  visibleWidth,
} from "@earendil-works/pi-tui";
import {
  CODEX_FAST_EVENT,
  DEFAULT_CODEX_FAST_ENABLED,
  formatCodexFastLabel,
} from "./codex-fast.ts";

const MODEL_INFO_EVENT = "dashboard:model-info";
const GIT_INFO_EVENT = "dashboard:git-info";
const REFRESH_EVENT = "dashboard:refresh";

type ModelInfo = {
  provider: string;
  modelId: string;
  thinking: string;
  contextWindow: number;
  contextPercent: number | null;
  cost: number;
  tokensPerSecond: number | null;
};

type PullRequest = { number: number; url: string };
type GitInfo = {
  isRepository: boolean;
  branch: string | null;
  changedFiles: number;
  pullRequest: PullRequest | null;
};
type DiffStat = { additions: number; deletions: number };

const emptyModelInfo = (): ModelInfo => ({
  provider: "",
  modelId: "no-model",
  thinking: "off",
  contextWindow: 0,
  contextPercent: null,
  cost: 0,
  tokensPerSecond: null,
});

const emptyGitInfo = (): GitInfo => ({
  isRepository: false,
  branch: null,
  changedFiles: 0,
  pullRequest: null,
});

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function isModelInfo(value: unknown): value is ModelInfo {
  return (
    isRecord(value) &&
    typeof value.provider === "string" &&
    typeof value.modelId === "string" &&
    typeof value.thinking === "string" &&
    typeof value.contextWindow === "number" &&
    (value.contextPercent === null ||
      typeof value.contextPercent === "number") &&
    typeof value.cost === "number" &&
    (value.tokensPerSecond === null ||
      typeof value.tokensPerSecond === "number")
  );
}

function isGitInfo(value: unknown): value is GitInfo {
  if (
    !isRecord(value) ||
    typeof value.isRepository !== "boolean" ||
    (value.branch !== null && typeof value.branch !== "string") ||
    typeof value.changedFiles !== "number"
  ) {
    return false;
  }

  return (
    value.pullRequest === null ||
    (isRecord(value.pullRequest) &&
      typeof value.pullRequest.number === "number" &&
      typeof value.pullRequest.url === "string")
  );
}

function sanitizeLabel(text: string): string {
  return text.replace(/[\u0000-\u001f\u007f-\u009f]/g, "");
}

function formatDirectory(cwd: string): string {
  const home = homedir();
  if (cwd === home) return "~";
  return sanitizeLabel(
    cwd.startsWith(`${home}/`) ? `~/${relative(home, cwd)}` : cwd,
  );
}

function formatTokens(tokens: number): string {
  if (tokens < 1_000) return `${tokens}`;
  if (tokens < 1_000_000) return `${Math.round(tokens / 1_000)}k`;
  return `${(tokens / 1_000_000).toFixed(1)}m`;
}

function columns(left: string, right: string, width: number): string {
  if (!right) return truncateToWidth(left, width);

  const gap = width - visibleWidth(left) - visibleWidth(right);
  if (gap >= 1) return `${left}${" ".repeat(gap)}${right}`;

  const leftWidth = Math.max(1, Math.floor(width * 0.45));
  const rightWidth = Math.max(1, width - leftWidth - 1);
  const fittedLeft = truncateToWidth(left, leftWidth);
  const fittedRight = truncateToWidth(right, rightWidth);
  return truncateToWidth(`${fittedLeft} ${fittedRight}`, width);
}

function parseNumstat(output: string): DiffStat {
  let additions = 0;
  let deletions = 0;

  for (const line of output.split("\n")) {
    const [added, deleted] = line.split("\t");
    const addedCount = Number(added);
    const deletedCount = Number(deleted);
    if (Number.isFinite(addedCount)) additions += addedCount;
    if (Number.isFinite(deletedCount)) deletions += deletedCount;
  }

  return { additions, deletions };
}

function formatGitStatus(theme: Theme, git: GitInfo, diff: DiffStat): string {
  if (git.changedFiles === 0) return theme.fg("success", "clean");
  if (diff.additions === 0 && diff.deletions === 0) {
    return theme.fg("warning", "dirty");
  }

  return `${theme.fg("success", `+${diff.additions}`)}/${theme.fg("error", `-${diff.deletions}`)}`;
}

export default function statusFooter(pi: ExtensionAPI) {
  let model = emptyModelInfo();
  let git = emptyGitInfo();
  let diff = { additions: 0, deletions: 0 };
  let fastEnabled = DEFAULT_CODEX_FAST_ENABLED;
  let context: ExtensionContext | undefined;
  let requestRender: (() => void) | undefined;
  let diffGeneration = 0;

  const refreshDiff = async () => {
    const current = context;
    const generation = ++diffGeneration;
    if (!current || !git.isRepository || git.changedFiles === 0) {
      diff = { additions: 0, deletions: 0 };
      requestRender?.();
      return;
    }

    const result = await pi.exec(
      "git",
      ["-C", current.cwd, "diff", "--numstat", "HEAD", "--"],
      { timeout: 3_000 },
    );
    if (generation !== diffGeneration || context !== current) return;

    diff =
      result.code === 0
        ? parseNumstat(result.stdout)
        : { additions: 0, deletions: 0 };
    requestRender?.();
  };

  const stopModelListener = pi.events.on(MODEL_INFO_EVENT, (value) => {
    if (!isModelInfo(value)) return;
    model = value;
    requestRender?.();
  });

  const stopGitListener = pi.events.on(GIT_INFO_EVENT, (value) => {
    if (!isGitInfo(value)) return;
    git = value;
    void refreshDiff();
    requestRender?.();
  });

  const stopFastListener = pi.events.on(CODEX_FAST_EVENT, (value) => {
    if (!isRecord(value) || typeof value.enabled !== "boolean") return;
    fastEnabled = value.enabled;
    requestRender?.();
  });

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    context = ctx;
    model = emptyModelInfo();
    git = emptyGitInfo();
    diff = { additions: 0, deletions: 0 };

    ctx.ui.setFooter((tui, theme, footerData: ReadonlyFooterDataProvider) => {
      requestRender = () => tui.requestRender();

      return {
        invalidate() {},
        render(width: number) {
          const directory = theme.fg("text", formatDirectory(ctx.cwd));
          const fast = formatCodexFastLabel(
            fastEnabled,
            model.provider,
            model.modelId,
          );
          const modelLabel = model.provider
            ? [
                `${sanitizeLabel(model.provider)}/${sanitizeLabel(model.modelId)}`,
                fast,
                sanitizeLabel(model.thinking),
              ]
                .filter(Boolean)
                .join(" · ")
            : sanitizeLabel(model.modelId);

          const contextPercent =
            model.contextPercent === null
              ? "?"
              : `${Math.round(model.contextPercent)}`;
          const contextWindow =
            model.contextWindow > 0 ? formatTokens(model.contextWindow) : "?";
          const speed =
            model.tokensPerSecond === null
              ? "— tok/s"
              : `${Math.round(model.tokensPerSecond)} tok/s`;
          const usage = `${contextPercent}%/${contextWindow} · $${model.cost.toFixed(2)} · ${speed}`;

          let gitLabel = git.branch
            ? `${sanitizeLabel(git.branch)} · ${formatGitStatus(theme, git, diff)}`
            : "";
          if (git.pullRequest) {
            const label = `PR #${git.pullRequest.number}`;
            const linked = getCapabilities().hyperlinks
              ? hyperlink(label, git.pullRequest.url)
              : label;
            gitLabel += ` · ${linked}`;
          }

          const lines = [
            columns(directory, theme.fg("muted", modelLabel), width),
            columns(theme.fg("muted", usage), gitLabel, width),
          ];

          const statuses = Array.from(
            footerData.getExtensionStatuses().entries(),
          )
            .sort(([left], [right]) => left.localeCompare(right))
            .flatMap(([, text]) => text.split("\n"));
          for (const status of statuses) {
            lines.push(truncateToWidth(status, width, theme.fg("dim", "...")));
          }

          return lines;
        },
      };
    });

    pi.events.emit(REFRESH_EVENT, undefined);
  });

  pi.on("session_shutdown", (_event, ctx) => {
    stopModelListener();
    stopGitListener();
    stopFastListener();
    diffGeneration += 1;
    context = undefined;
    requestRender = undefined;
    if (ctx.mode === "tui") ctx.ui.setFooter(undefined);
  });
}
