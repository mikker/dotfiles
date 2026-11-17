# run

One long-running dev command per folder (a server, a watcher), run by Superego next to the threads that work there.
Each folder a thread works in, a worktree included, has its own runner, and threads in the same folder share it.

- **Header pill**: the folder's state (Run, Starting with a pulse, Running, Stopped, Failed). Click it to see the output.
  Idle, it shows (as Run) wherever the folder has a config, and nowhere else.
- **Sidebar mark**: a small terminal glyph on the thread's row while its command starts, runs, or has failed.
- **Output pane** (*Run output*, in the pane menu): a live tail with ANSI colours. It follows the end, stops following
  when you scroll up (*Follow* takes you back), and has Restart/Start and Stop buttons.
- **Agent tools**: `run_status`, `run_logs` (the last N lines of the current run, or of everything kept), `run_restart`,
  `run_stop`, and a short prompt section asking the agent to use them rather than starting the server itself.

## Config

Add `.superego/run.json` to the project:

```json
{ "command": ["just", "run"], "ready": "STATUS:READY", "grace": 5, "env": { "PORT": "3000" } }
```

| Key | |
|---|---|
| `command` | an argv array (quoted for you) or a shell string. Required |
| `ready` | text that marks it ready once it appears in the output (colour codes ignored). Without it, it counts as running as soon as it starts |
| `grace` | seconds between SIGTERM and SIGKILL when stopping. Default 5 |
| `env` | extra environment variables |

Run looks for the file in the thread's folder, then in each folder above it, stopping at the repository root (the
first folder with `.git`). The command runs in the folder that holds `.superego/`. If no file is found, the setting
`run.command` (Settings → Run, or `superego settings set run.command "just run"`) is used as a default. With neither,
run says how to add a config. It doesn't guess commands from `package.json` or similar, and nothing starts on its own.

The command runs in your `$SHELL` as a login, interactive shell (`-l -i -c`), so your PATH and aliases work as they do
in your terminal. Job control is off and SIGTERM ends the shell, so the shell and everything it starts form one
process group that stops together.

## Actions

| Action | |
|---|---|
| `run.restart` | start it, or restart it if it's running |
| `run.stop` | SIGTERM to the whole group, SIGKILL after the grace |
| `run.logs` | open the output pane |

No keyboard shortcut yet: bind one in Settings → Keyboard if you want it.

From ⌘K, or the command line: `superego do run.restart --thread <id>` (`--folder <path>` also works). If several restarts overlap, the newest wins: exactly one process starts, and every caller gets its status
back.

## Status and output

- `run.status`, a live value scoped by folder: `{ state, command, ready, pid, startedAt, endedAt, exitCode, signal, error, config }`.
  `config` is what `run.config` last found (`{ found, path, command, ready }` or `{ found: false, error }`): looked
  at as the daemon half sets up (for every thread's folder), as a thread there is made or starts a turn, on every
  start, and whenever the window asks (`run.config`: as it shows the thread, and as it comes back to the front). The
  pill and the pane read it from here, so a config added later shows without a reload. The state is `idle`, then `starting` (until the ready text appears), `running`, then `stopped` (you stopped it, or it
  exited 0) or `failed` (a non-zero exit, or it couldn't start).
- `run.output`, scoped by folder: `{ end, start }`. It moves as output arrives, at most every 100ms. The pane reads the
  new part with the `run.read` method.
- The last ~1 MB of output stays in memory. All of it goes to `~/.superego/run/<hash>/run.log`, rotated to
  `run.log.1` at 2 MiB, with `── start ──` and `── stopped / exited ──` lines between runs. The `folder` file next
  to it records which folder the log belongs to.

## Lifecycle and tradeoffs

- Archiving the last thread in a folder stops that folder's command. This happens while the thread is being archived,
  so it runs before a worktree is removed.
- **A profile reload or a daemon restart stops every runner.** The processes belong to the extension's set-up, and the
  teardown stops them so nothing is orphaned. Restart afterwards from the pill's pane or ⌘K. Output kept in memory is lost too; the log
  file keeps it.
- It's one command per folder. For several processes, run a process manager as the command.
- stdin stays open but is never written to. A tool that waits for keyboard input will just wait.

## Files

`daemon.ts` (runners, actions, tools), `config.ts` (finding and parsing `run.json`, the shell invocation),
`output.ts` (the in-memory buffer, the rotating log, ANSI stripping), `ansi.ts` (ANSI to styled runs, for the pane),
`ui.tsx` (pill, mark, pane), `shared.ts`. Tests: `superego extension test run --user`.

The `chief-of-staff` profile has run too: it lists `../default/run/daemon.ts` (both profiles share one set-up, and so
the same runners) and `./run/ui.tsx` through `chief-of-staff/run`, a symlink to this folder. The window loads a
profile's UI only from inside that profile's folder: listed as `../default/run/ui.tsx`, the profile's whole UI is
refused (the console says "… is outside the profile") and its threads get no pill. A test checks that every profile
listing run serves its UI as the window loads it.
