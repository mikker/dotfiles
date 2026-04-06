import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { DynamicBorder } from "@mariozechner/pi-coding-agent";
import { Container, type SelectItem, SelectList, Text } from "@mariozechner/pi-tui";

const WINDOW_MARKER_RE = / [🟢🟡🔴]$/;
const AGENT_ORDER = ["pi", "amp", "claude", "codex"] as const;

type AgentName = (typeof AGENT_ORDER)[number];

interface WorktreeInfo {
	name: string;
	path: string;
	branch: string | null;
	dirty: boolean;
	relation: string;
	parked: boolean;
	agents: AgentName[];
	focusWindowId?: string;
	current: boolean;
}

interface Snapshot {
	repoRoot: string;
	integrationBranch: string;
	tables: WorktreeInfo[];
	tmuxSession?: string;
}

function unique<T>(values: Iterable<T>): T[] {
	return [...new Set(values)];
}

function stripWindowMarker(name: string): string {
	return name.replace(WINDOW_MARKER_RE, "");
}

function windowIsParked(name: string): boolean {
	return / 🟡$/.test(name);
}

function deriveTableName(path: string, repoRoot: string, integrationBranch: string): string {
	if (path === repoRoot) return integrationBranch;

	const repoBase = repoRoot.split("/").filter(Boolean).at(-1) ?? repoRoot;
	const match = path.match(new RegExp(`/${repoBase}-worktrees/([^/]+)$`));
	if (match?.[1]) return match[1];

	return path.split("/").filter(Boolean).at(-1) ?? path;
}

function parseWorktreeList(stdout: string, repoRoot: string, integrationBranch: string): Array<{ path: string; branch: string | null }> {
	const blocks = stdout.trim().split(/\n(?=worktree )/).filter(Boolean);
	return blocks
		.map((block) => {
			let path = "";
			let branch: string | null = null;
			for (const line of block.split("\n")) {
				if (line.startsWith("worktree ")) path = line.slice("worktree ".length).trim();
				if (line.startsWith("branch refs/heads/")) branch = line.slice("branch refs/heads/".length).trim();
			}
			if (!path) return undefined;
			return { path, branch };
		})
		.filter((entry): entry is { path: string; branch: string | null } => !!entry)
		.map((entry) => ({
			...entry,
			branch: entry.path === repoRoot && !entry.branch ? integrationBranch : entry.branch,
		}));
}

function relationFromCounts(integrationBranch: string, branch: string | null, counts: string): string {
	if (!branch) return "detached";
	if (branch === integrationBranch) return `current ${integrationBranch}`;

	const [leftText, rightText] = counts.trim().split(/\s+/, 2);
	const mainOnly = Number.parseInt(leftText ?? "0", 10) || 0;
	const branchOnly = Number.parseInt(rightText ?? "0", 10) || 0;

	if (mainOnly === 0 && branchOnly === 0) return `matches ${integrationBranch}`;
	if (mainOnly === 0) return `ahead +${branchOnly}`;
	if (branchOnly === 0) return `behind ${mainOnly}`;
	return `diverged +${branchOnly}/-${mainOnly}`;
}

function classifyAgent(command: string, title: string): AgentName | undefined {
	const text = `${command} ${title}`.toLowerCase();
	if (/\bamp\b/.test(text)) return "amp";
	if (/\bclaude\b/.test(text)) return "claude";
	if (/\bcodex\b/.test(text)) return "codex";
	if (/\bpi\b/.test(text) || /(^|\s)π(\s|$)/.test(text)) return "pi";
	return undefined;
}

function collectDescendantCommands(rootPid: number, childrenByParent: Map<number, number[]>, commandByPid: Map<number, string>): string[] {
	const queue = [...(childrenByParent.get(rootPid) ?? [])];
	const descendants: string[] = [];

	while (queue.length > 0) {
		const pid = queue.shift()!;
		const command = commandByPid.get(pid);
		if (command) descendants.push(command);
		for (const child of childrenByParent.get(pid) ?? []) queue.push(child);
	}

	return descendants;
}

function formatAgents(agents: AgentName[]): string {
	return agents.length > 0 ? `agents: ${agents.join(", ")}` : "no agents";
}

function formatTableDescription(table: WorktreeInfo): string {
	const parts = [table.branch ?? "detached", table.dirty ? "dirty" : "clean", table.relation];
	if (table.parked) parts.push("parked");
	parts.push(formatAgents(table.agents));
	return parts.join(" · ");
}

function formatCurrentTableDetail(table: WorktreeInfo): string {
	const parts = [`table ${table.name}`, table.branch ?? "detached", table.dirty ? "dirty" : "clean", table.relation];
	if (table.parked) parts.push("parked");
	if (table.agents.length > 0) parts.push(table.agents.join(", "));
	return parts.join(" · ");
}

async function run(pi: ExtensionAPI, command: string, args: string[]): Promise<{ code: number; stdout: string; stderr: string }> {
	const result = await pi.exec(command, args);
	return {
		code: result.code,
		stdout: result.stdout ?? "",
		stderr: result.stderr ?? "",
	};
}

async function detectRepoRoot(pi: ExtensionAPI, cwd: string): Promise<string | undefined> {
	const result = await run(pi, "git", ["-C", cwd, "rev-parse", "--show-toplevel"]);
	if (result.code !== 0) return undefined;
	const root = result.stdout.trim();
	return root || undefined;
}

async function detectIntegrationBranch(pi: ExtensionAPI, repoRoot: string): Promise<string> {
	for (const name of ["main", "master"]) {
		const result = await run(pi, "git", ["-C", repoRoot, "show-ref", "--verify", `refs/heads/${name}`]);
		if (result.code === 0) return name;
	}
	return "main";
}

async function detectTmuxSession(pi: ExtensionAPI): Promise<string | undefined> {
	if (!process.env.TMUX) return undefined;
	const result = await run(pi, "tmux", ["display-message", "-p", "#S"]);
	if (result.code !== 0) return undefined;
	const session = result.stdout.trim();
	return session || undefined;
}

async function inspectSnapshot(pi: ExtensionAPI, ctx: ExtensionContext): Promise<Snapshot | undefined> {
	const repoRoot = await detectRepoRoot(pi, ctx.cwd);
	if (!repoRoot) return undefined;

	const integrationBranch = await detectIntegrationBranch(pi, repoRoot);
	const worktreeResult = await run(pi, "git", ["-C", repoRoot, "worktree", "list", "--porcelain"]);
	if (worktreeResult.code !== 0) return undefined;

	const parsedWorktrees = parseWorktreeList(worktreeResult.stdout, repoRoot, integrationBranch);
	const tmuxSession = await detectTmuxSession(pi);

	const windowByName = new Map<
		string,
		{
			parked: boolean;
			agents: AgentName[];
			focusWindowId?: string;
		}
	>();

	if (tmuxSession) {
		const [windowsResult, panesResult, psResult] = await Promise.all([
			run(pi, "tmux", ["list-windows", "-t", tmuxSession, "-F", "#{window_id}\t#{window_index}\t#{window_name}"]),
			run(
				pi,
				"tmux",
				[
					"list-panes",
					"-s",
					"-t",
					tmuxSession,
					"-F",
					"#{window_id}\t#{window_name}\t#{pane_pid}\t#{pane_current_command}\t#{pane_title}",
				],
			),
			run(pi, "ps", ["-axo", "pid=,ppid=,command="]),
		]);

		if (windowsResult.code === 0 && panesResult.code === 0 && psResult.code === 0) {
			const childrenByParent = new Map<number, number[]>();
			const commandByPid = new Map<number, string>();
			for (const line of psResult.stdout.split("\n")) {
				const match = line.match(/^\s*(\d+)\s+(\d+)\s+(.*)$/);
				if (!match) continue;
				const pid = Number.parseInt(match[1] ?? "", 10);
				const ppid = Number.parseInt(match[2] ?? "", 10);
				const command = match[3] ?? "";
				commandByPid.set(pid, command);
				childrenByParent.set(ppid, [...(childrenByParent.get(ppid) ?? []), pid]);
			}

			const agentsByWindowId = new Map<string, AgentName[]>();
			for (const line of panesResult.stdout.split("\n")) {
				if (!line.trim()) continue;
				const [windowId = "", rawWindowName = "", panePidText = "", paneCommand = "", paneTitle = ""] = line.split("\t");
				const panePid = Number.parseInt(panePidText, 10);
				const commands = Number.isFinite(panePid)
					? collectDescendantCommands(panePid, childrenByParent, commandByPid)
					: [];
				const detected = unique(
					[...commands, paneCommand]
						.map((command) => classifyAgent(command, paneTitle))
						.filter((value): value is AgentName => !!value),
				).sort((a, b) => AGENT_ORDER.indexOf(a) - AGENT_ORDER.indexOf(b));
				agentsByWindowId.set(windowId, unique([...(agentsByWindowId.get(windowId) ?? []), ...detected]));
				const cleanedName = stripWindowMarker(rawWindowName);
				if (!windowByName.has(cleanedName)) {
					windowByName.set(cleanedName, { parked: false, agents: [] });
				}
			}

			for (const line of windowsResult.stdout.split("\n")) {
				if (!line.trim()) continue;
				const [windowId = "", windowIndexText = "", rawWindowName = ""] = line.split("\t");
				const cleanedName = stripWindowMarker(rawWindowName);
				const parked = windowIsParked(rawWindowName);
				const windowAgents = (agentsByWindowId.get(windowId) ?? []).sort(
					(a, b) => AGENT_ORDER.indexOf(a) - AGENT_ORDER.indexOf(b),
				);
				const current = windowByName.get(cleanedName) ?? { parked: false, agents: [] };
				const mergedAgents = unique([...current.agents, ...windowAgents]).sort(
					(a, b) => AGENT_ORDER.indexOf(a) - AGENT_ORDER.indexOf(b),
				);
				const next = {
					parked: current.parked || parked,
					agents: mergedAgents,
					focusWindowId: current.focusWindowId,
				};
				const windowIndex = Number.parseInt(windowIndexText, 10) || 0;
				const shouldUseForFocus = !next.focusWindowId || (windowAgents.length > 0 && current.agents.length === 0);
				if (shouldUseForFocus || (!next.focusWindowId && windowIndex >= 0)) next.focusWindowId = windowId;
				windowByName.set(cleanedName, next);
			}
		}
	}

	const tables: WorktreeInfo[] = [];
	for (const worktree of parsedWorktrees) {
		const name = deriveTableName(worktree.path, repoRoot, integrationBranch);
		const [dirtyResult, relationResult] = await Promise.all([
			run(pi, "git", ["-C", worktree.path, "status", "--porcelain"]),
			worktree.branch
				? run(pi, "git", ["-C", repoRoot, "rev-list", "--left-right", "--count", `${integrationBranch}...${worktree.branch}`])
				: Promise.resolve({ code: 0, stdout: "", stderr: "" }),
		]);
		const tmuxInfo = windowByName.get(name);
		tables.push({
			name,
			path: worktree.path,
			branch: worktree.branch,
			dirty: dirtyResult.stdout.trim().length > 0,
			relation: relationFromCounts(integrationBranch, worktree.branch, relationResult.stdout),
			parked: tmuxInfo?.parked ?? false,
			agents: tmuxInfo?.agents ?? [],
			focusWindowId: tmuxInfo?.focusWindowId,
			current: worktree.path === repoRoot,
		});
	}

	return { repoRoot, integrationBranch, tables, tmuxSession };
}

export default function worktablesExtension(pi: ExtensionAPI) {
	let lastSnapshot: Snapshot | undefined;
	let lastCtx: ExtensionContext | undefined;

	async function refreshStatus(ctx: ExtensionContext): Promise<void> {
		lastCtx = ctx;
		lastSnapshot = await inspectSnapshot(pi, ctx);
		const current = lastSnapshot?.tables.find((table) => table.current);
		if (!current) {
			ctx.ui.setStatus("worktables", undefined);
			pi.events.emit("worktables:status", { detail: "" });
			return;
		}

		const detail = formatCurrentTableDetail(current);
		ctx.ui.setStatus("worktables", ctx.ui.theme.fg("dim", detail));
		pi.events.emit("worktables:status", { detail });
	}

	async function ensureSnapshot(ctx: ExtensionContext): Promise<Snapshot | undefined> {
		if (!lastSnapshot || !lastCtx || lastCtx.cwd !== ctx.cwd) {
			await refreshStatus(ctx);
		}
		return lastSnapshot;
	}

	async function focusTable(name: string, ctx: ExtensionContext): Promise<void> {
		const snapshot = await ensureSnapshot(ctx);
		if (!snapshot) {
			ctx.ui.notify("No git worktables found from this directory", "warning");
			return;
		}

		const table = snapshot.tables.find((item) => item.name === name);
		if (!table) {
			ctx.ui.notify(`Unknown table: ${name}`, "warning");
			return;
		}
		if (!snapshot.tmuxSession || !table.focusWindowId) {
			ctx.ui.notify(`No tmux window found for table ${name}`, "warning");
			return;
		}

		const result = await run(pi, "tmux", ["select-window", "-t", table.focusWindowId]);
		if (result.code !== 0) {
			ctx.ui.notify(`Failed to focus table ${name}: ${result.stderr.trim() || result.stdout.trim()}`, "error");
		}
	}

	async function showTablesPicker(ctx: ExtensionContext): Promise<void> {
		const snapshot = await ensureSnapshot(ctx);
		if (!snapshot || snapshot.tables.length === 0) {
			ctx.ui.notify("No worktables found", "warning");
			return;
		}

		const items: SelectItem[] = snapshot.tables.map((table) => ({
			value: table.name,
			label: table.current ? `${table.name} (current)` : table.name,
			description: formatTableDescription(table),
		}));

		const selected = await ctx.ui.custom<string | null>((tui, theme, _kb, done) => {
			const container = new Container();
			container.addChild(new DynamicBorder((text: string) => theme.fg("accent", text)));
			container.addChild(new Text(theme.fg("accent", theme.bold("Worktables"))));
			container.addChild(new Text(theme.fg("dim", `integration: ${snapshot.integrationBranch} · enter focuses table`)));

			const list = new SelectList(items, Math.min(Math.max(items.length, 1), 10), {
				selectedPrefix: (text) => theme.fg("accent", text),
				selectedText: (text) => theme.fg("accent", text),
				description: (text) => theme.fg("muted", text),
				scrollInfo: (text) => theme.fg("dim", text),
				noMatch: (text) => theme.fg("warning", text),
			});
			list.onSelect = (item) => done(String(item.value));
			list.onCancel = () => done(null);
			container.addChild(list);
			container.addChild(new DynamicBorder((text: string) => theme.fg("accent", text)));

			return {
				render(width: number) {
					return container.render(width);
				},
				invalidate() {
					container.invalidate();
				},
				handleInput(data: string) {
					list.handleInput?.(data);
					tui.requestRender();
				},
			};
		});

		if (selected) await focusTable(selected, ctx);
	}

	pi.registerCommand("tables", {
		description: "Show worktables and focus one",
		handler: async (_args, ctx) => {
			await refreshStatus(ctx);
			await showTablesPicker(ctx);
		},
	});

	pi.registerCommand("table", {
		description: "Focus a worktable by name",
		handler: async (args, ctx) => {
			const name = args.trim();
			if (!name) {
				await showTablesPicker(ctx);
				return;
			}
			await refreshStatus(ctx);
			await focusTable(name, ctx);
		},
	});

	pi.registerCommand("sync-tables", {
		description: "Run just sync-trees from the current repo",
		handler: async (_args, ctx) => {
			const snapshot = await ensureSnapshot(ctx);
			if (!snapshot) {
				ctx.ui.notify("No git repo found", "warning");
				return;
			}
			ctx.ui.notify("Running just sync-trees…", "info");
			const result = await run(pi, "just", ["-f", `${snapshot.repoRoot}/justfile`, "sync-trees"]);
			if (result.code === 0) {
				ctx.ui.notify("sync-trees complete", "success");
			} else {
				const message = (result.stderr.trim() || result.stdout.trim() || "sync-trees failed").split("\n").slice(-1)[0];
				ctx.ui.notify(message || "sync-trees failed", "error");
			}
			await refreshStatus(ctx);
		},
	});

	pi.on("session_start", async (_event, ctx) => {
		await refreshStatus(ctx);
	});

	pi.on("turn_end", async (_event, ctx) => {
		await refreshStatus(ctx);
	});

	pi.on("session_shutdown", async () => {
		lastSnapshot = undefined;
		lastCtx = undefined;
		pi.events.emit("worktables:status", { detail: "" });
	});
}
