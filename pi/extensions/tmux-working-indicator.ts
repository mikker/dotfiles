import { execFile } from "node:child_process";
import { promisify } from "node:util";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const execFileAsync = promisify(execFile);
const PID = String(process.pid);
const PID_OPTION = "@pi_working_pids";
const GLYPH = "󱚣";
const GLYPH_PAD = `  ${GLYPH} `;
const OPTIONS = ["window-status-format", "window-status-current-format"];

export default function (pi: ExtensionAPI) {
	if (!process.env.TMUX) return;

	pi.on("session_start", async () => {
		await removePid();
	});

	pi.on("agent_start", async () => {
		await addPid();
		await setGlyph(true);
	});

	pi.on("agent_end", async () => {
		await removePid();
		if ((await livePids()).length === 0) await setGlyph(false);
	});

	pi.on("session_shutdown", async () => {
		await removePid();
		if ((await livePids()).length === 0) await setGlyph(false);
	});
};

async function setGlyph(show: boolean) {
	for (const option of OPTIONS) {
		const format = await tmux(["show-options", "-gqv", option]);
		await tmux(["set-option", "-gq", option, show ? addGlyph(format) : removeGlyph(format)]);
	}
}

function addGlyph(format: string) {
	const clean = removeGlyph(format);
	if (!clean) return clean;

	const windowName = clean.lastIndexOf("#W");
	if (windowName !== -1) {
		return `${clean.slice(0, windowName)}#{?${PID_OPTION},#W${GLYPH_PAD},#W}${clean.slice(windowName + 2)}`;
	}

	return clean.replace(/([a-z0-9])(?!.*[a-z0-9])/i, `#{?${PID_OPTION},$1${GLYPH_PAD},$1}`);
}

function removeGlyph(format: string) {
	return format
		.replace(new RegExp(`#\\{\\?${PID_OPTION},#W[^,}]*${GLYPH}[^,}]*,#W\\s*\\}`, "gu"), "#W")
		.replace(new RegExp(`#\\{\\?${PID_OPTION},([a-z0-9])[^,}]*${GLYPH}[^,}]*,\\1\\s*\\}`, "giu"), "$1")
		.replace(new RegExp(` {1,2}${GLYPH} ?`, "gu"), "");
}

async function addPid() {
	const pids = await livePids();
	if (!pids.includes(PID)) pids.push(PID);
	await tmux(["set-window-option", "-q", PID_OPTION, pids.join(",")]);
}

async function removePid() {
	const pids = (await livePids()).filter((pid) => pid !== PID);
	if (pids.length === 0) {
		await tmux(["set-window-option", "-qu", PID_OPTION]);
	} else {
		await tmux(["set-window-option", "-q", PID_OPTION, pids.join(",")]);
	}
}

async function livePids() {
	const raw = await tmux(["show-options", "-wqv", PID_OPTION]);
	return raw.split(",").map((pid) => pid.trim()).filter(isLivePid);
}

function isLivePid(pid: string) {
	if (!/^\d+$/.test(pid)) return false;
	try {
		process.kill(Number(pid), 0);
		return true;
	} catch {
		return false;
	}
}

async function tmux(args: string[]) {
	try {
		const { stdout } = await execFileAsync("tmux", args, { env: process.env });
		return stdout.replace(/\n$/, "");
	} catch {
		return "";
	}
}
