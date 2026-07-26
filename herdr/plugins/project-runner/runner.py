#!/usr/bin/env python3
import json
import os
from pathlib import Path
import subprocess
import sys
import tomllib
from urllib.parse import quote

PLUGIN_ID = "mikker.project-runner"
ENTRYPOINT = "runner"
CONFIG_PATH = Path(".herdr/run.toml")
PLACEMENTS = {"overlay", "split", "tab", "zoomed"}


def herdr(*args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [os.environ.get("HERDR_BIN_PATH", "herdr"), *args],
        check=check,
        text=True,
        capture_output=True,
    )


def notify(title: str, body: str = "") -> None:
    args = ["notification", "show", title]
    if body:
        args.extend(["--body", body])
    herdr(*args, check=False)


def invocation_context() -> dict[str, object]:
    raw = os.environ.get("HERDR_PLUGIN_CONTEXT_JSON", "{}")
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return {}


def project_config() -> Path | None:
    context = invocation_context()
    cwd = context.get("workspace_cwd") or context.get("focused_pane_cwd")
    if not isinstance(cwd, str):
        return None

    path = Path(cwd).resolve() / CONFIG_PATH
    return path if path.is_file() else None


def load_config(path: Path) -> tuple[list[str], str, str]:
    with path.open("rb") as file:
        config = tomllib.load(file)

    command = config.get("command")
    if not isinstance(command, list) or not command or not all(isinstance(arg, str) for arg in command):
        raise ValueError('command must be a non-empty array, e.g. command = ["just", "run"]')

    placement = config.get("placement", "tab")
    if placement not in PLACEMENTS:
        raise ValueError(f"placement must be one of: {', '.join(sorted(PLACEMENTS))}")

    name = config.get("name", " ".join(command))
    if not isinstance(name, str) or not name.strip():
        raise ValueError("name must be a non-empty string")

    return command, placement, name


def workspace_id() -> str | None:
    value = os.environ.get("HERDR_WORKSPACE_ID") or invocation_context().get("workspace_id")
    return value if isinstance(value, str) and value else None


def state_path(workspace: str) -> Path:
    directory = Path(os.environ["HERDR_PLUGIN_STATE_DIR"]) / "runners"
    directory.mkdir(parents=True, exist_ok=True)
    return directory / f"{quote(workspace, safe='')}.json"


def close_existing(workspace: str) -> None:
    path = state_path(workspace)
    try:
        pane_id = json.loads(path.read_text())["pane_id"]
    except (FileNotFoundError, KeyError, json.JSONDecodeError):
        return

    herdr("plugin", "pane", "close", pane_id, check=False)
    path.unlink(missing_ok=True)


def restart() -> None:
    workspace = workspace_id()
    config_path = project_config()
    if not workspace or not config_path:
        notify("No project runner", f"Expected {CONFIG_PATH}")
        return

    try:
        _, placement, name = load_config(config_path)
    except (OSError, tomllib.TOMLDecodeError, ValueError) as error:
        notify("Invalid project runner config", str(error))
        raise SystemExit(str(error))

    close_existing(workspace)
    result = herdr(
        "plugin",
        "pane",
        "open",
        "--plugin",
        PLUGIN_ID,
        "--entrypoint",
        ENTRYPOINT,
        "--placement",
        placement,
        "--workspace",
        workspace,
        "--cwd",
        str(config_path.parent.parent),
        "--env",
        f"HERDR_RUN_CONFIG={config_path}",
        "--focus",
    )

    response = json.loads(result.stdout)
    pane = response["result"]["plugin_pane"]["pane"]
    pane_id = pane["pane_id"]
    if placement == "tab":
        herdr("tab", "rename", pane["tab_id"], name)
    state_path(workspace).write_text(json.dumps({"pane_id": pane_id}) + "\n")


def stop() -> None:
    workspace = workspace_id()
    if not workspace:
        notify("No active workspace")
        return
    close_existing(workspace)
    notify("Project runner stopped")


def run() -> None:
    raw_path = os.environ.get("HERDR_RUN_CONFIG")
    if not raw_path:
        raise SystemExit("HERDR_RUN_CONFIG is unavailable")

    config_path = Path(raw_path)
    command, _, _ = load_config(config_path)
    os.chdir(config_path.parent.parent)
    os.execvp(command[0], command)


def main() -> None:
    actions = {"restart": restart, "stop": stop, "run": run}
    try:
        action = actions[sys.argv[1]]
    except (IndexError, KeyError):
        raise SystemExit("usage: runner.py <restart|stop|run>")
    action()


if __name__ == "__main__":
    main()
