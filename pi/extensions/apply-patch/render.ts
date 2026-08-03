// Dotfiles-managed Pi extension.

import { renderDiff, type Theme } from "@earendil-works/pi-coding-agent";
import {
  type Component,
  Container,
  Spacer,
  Text,
} from "@earendil-works/pi-tui";
import type { ApplyPatchDetails, ApplyPatchFileDiff } from "./tool";

export interface ApplyPatchRenderState {
  callComponent?: Text;
}

interface ApplyPatchRenderContext<T> {
  state: ApplyPatchRenderState;
  lastComponent?: Component;
  args?: T;
}

function getCallComponent(
  state: ApplyPatchRenderState,
  lastComponent: Component | undefined,
): Text {
  if (lastComponent instanceof Text) {
    state.callComponent = lastComponent;
    return lastComponent;
  }
  if (state.callComponent) return state.callComponent;

  const component = new Text("", 0, 0);
  state.callComponent = component;
  return component;
}

function extractTextOutput(result: {
  content: Array<{ type: string; text?: string }>;
}): string {
  return result.content
    .filter((item) => item.type === "text")
    .map((item) => item.text ?? "")
    .join("\n");
}

function summarizeDiff(diff: string): {
  additions: number;
  removals: number;
} {
  let additions = 0;
  let removals = 0;
  for (const line of diff.split("\n")) {
    if (line.startsWith("+")) additions++;
    else if (line.startsWith("-")) removals++;
  }
  return { additions, removals };
}

export function extractFileOps(patch: string): string[] {
  return extractFileOpDetails(patch).map((op) => `${op.status} ${op.path}`);
}

interface FileOpSummary {
  status: "A" | "D" | "M";
  path: string;
}

function extractFileOpDetails(patch: string): FileOpSummary[] {
  const ops: FileOpSummary[] = [];
  const re = /^\*\*\* (Add|Delete|Update) File: (.+)$/gm;
  let match = re.exec(patch);
  while (match !== null) {
    const action = match[1] ?? "Update";
    const path = match[2] ?? "";
    const verb = action === "Add" ? "A" : action === "Delete" ? "D" : "M";
    ops.push({ status: verb, path });
    match = re.exec(patch);
  }
  return ops;
}

export function renderApplyPatchCall(
  args: { input?: string },
  theme: Theme,
  context: ApplyPatchRenderContext<{ input?: string }>,
) {
  const ops = extractFileOpDetails(args.input ?? "");
  const detail = formatCallSummary(ops, theme);
  const component = getCallComponent(context.state, context.lastComponent);
  component.setText(
    `${theme.fg("toolTitle", theme.bold("apply_patch"))} ${detail}`,
  );
  return component;
}

export function renderApplyPatchResult(
  result: {
    content: Array<{ type: string; text?: string }>;
    details?: ApplyPatchDetails;
  },
  options: { expanded: boolean },
  theme: Theme,
  context: { isError: boolean; lastComponent?: Component },
) {
  const component = (
    context.lastComponent instanceof Container
      ? context.lastComponent
      : new Container()
  ) as Container;
  component.clear();

  const output = context.isError
    ? theme.fg("error", extractTextOutput(result))
    : options.expanded
      ? formatExpandedDiff(result.details, theme)
      : formatApplyPatchSummary(result.details?.summary, result.details, theme);

  if (!output) return component;

  component.addChild(new Spacer(1));
  component.addChild(new Text(output, 0, 0));
  return component;
}

function formatApplyPatchSummary(
  summary: string[] | undefined,
  details: ApplyPatchDetails | undefined,
  theme: Theme,
): string | undefined {
  if (!summary || summary.length === 0) return undefined;
  const fileDiffs = getFileDiffCounts(details);
  return summary
    .map((line) => {
      const { status, path } = splitSummaryLine(line);
      const stat = renderFileStat(fileDiffs.get(path), theme);
      return `${formatStatus(status, theme)}  ${theme.fg("toolOutput", path)}${stat}`;
    })
    .join("\n");
}

function getFileDiffCounts(
  details: ApplyPatchDetails | undefined,
): Map<string, { additions: number; removals: number }> {
  const map = new Map<string, { additions: number; removals: number }>();
  if (!details?.fileDiffs) return map;
  for (const fileDiff of details.fileDiffs) {
    map.set(fileDiff.path, summarizeDiff(fileDiff.diff));
  }
  return map;
}

function renderFileStat(
  counts: { additions: number; removals: number } | undefined,
  theme: Theme,
): string {
  if (!counts) return "";
  const parts: string[] = [];
  if (counts.additions > 0) {
    parts.push(theme.fg("success", `+${counts.additions}`));
  }
  if (counts.removals > 0) {
    parts.push(theme.fg("error", `-${counts.removals}`));
  }
  if (parts.length === 0) return "";
  return `  ${theme.fg("dim", "(")}${parts.join(theme.fg("dim", " "))}${theme.fg("dim", ")")}`;
}

function formatExpandedDiff(
  details: ApplyPatchDetails | undefined,
  theme: Theme,
): string | undefined {
  if (!details) return undefined;
  const fileDiffs =
    details.fileDiffs && details.fileDiffs.length > 0
      ? details.fileDiffs
      : parseFileDiffs(details.diff, details.summary);
  if (fileDiffs.length === 0) {
    return details.diff ? renderDiff(details.diff) : undefined;
  }
  return fileDiffs
    .map(
      (fileDiff) =>
        `${formatExpandedPath(fileDiff, theme)}\n${renderDiff(fileDiff.diff)}`,
    )
    .join("\n\n");
}

function formatExpandedPath(
  fileDiff: ApplyPatchFileDiff,
  theme: Theme,
): string {
  const stat = renderFileStat(summarizeDiff(fileDiff.diff), theme);
  return `${formatStatus(fileDiff.status, theme)}  ${theme.fg("accent", theme.bold(fileDiff.path))}${stat}`;
}

function parseFileDiffs(
  diff: string | undefined,
  summary: string[] | undefined,
): ApplyPatchFileDiff[] {
  if (!diff) return [];
  const statuses = new Map(
    (summary ?? []).map((line) => {
      const { status, path } = splitSummaryLine(line);
      return [path, status === "A" || status === "D" ? status : "M"] as const;
    }),
  );

  return diff
    .split(/\n\n+/)
    .map((section) => {
      const [path, ...lines] = section.split("\n");
      if (!path || lines.length === 0) return undefined;
      return {
        status: statuses.get(path) ?? "M",
        path,
        diff: lines.join("\n"),
      } satisfies ApplyPatchFileDiff;
    })
    .filter(
      (fileDiff): fileDiff is ApplyPatchFileDiff => fileDiff !== undefined,
    );
}

function formatCallSummary(ops: FileOpSummary[], theme: Theme): string {
  if (ops.length === 0) return theme.fg("dim", "V4A patch");

  const counts = countByStatus(ops);
  const parts: string[] = [];
  if (counts.updated > 0)
    parts.push(formatCallCount(counts.updated, "updated", "M", theme));
  if (counts.created > 0)
    parts.push(formatCallCount(counts.created, "created", "A", theme));
  if (counts.deleted > 0)
    parts.push(formatCallCount(counts.deleted, "deleted", "D", theme));
  if (parts.length === 0)
    return theme.fg("dim", `${ops.length} file${ops.length === 1 ? "" : "s"}`);
  return parts.join(theme.fg("dim", ", "));
}

function countByStatus(ops: FileOpSummary[]): {
  updated: number;
  created: number;
  deleted: number;
} {
  let updated = 0;
  let created = 0;
  let deleted = 0;
  for (const op of ops) {
    if (op.status === "A") created++;
    else if (op.status === "D") deleted++;
    else updated++;
  }
  return { updated, created, deleted };
}

function formatCallCount(
  count: number,
  label: string,
  status: FileOpSummary["status"],
  theme: Theme,
): string {
  const text = `+${count} ${label}`;
  if (status === "A") return theme.fg("success", text);
  if (status === "D") return theme.fg("error", text);
  return theme.fg("warning", text);
}

function splitSummaryLine(line: string): { status: string; path: string } {
  const match = line.match(/^([^ ]+)\s+(.+)$/);
  if (!match) return { status: "M", path: line };
  return { status: match[1] ?? "M", path: match[2] ?? "" };
}

function formatStatus(status: string, theme: Theme): string {
  if (status === "A") return theme.fg("success", status);
  if (status === "D") return theme.fg("error", status);
  if (status === "O") return theme.fg("warning", status);
  if (status === "M") return theme.fg("warning", status);
  return theme.fg("accent", status);
}
