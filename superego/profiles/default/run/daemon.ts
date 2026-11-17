// run, daemon half: one long-running dev command per folder (a thread's cwd), from the project's `.superego/run.json`.
// It runs in the user's login shell as a process group of its own, its status a live value scoped by folder, its
// output kept in memory (about 1 MB) and in a rotating log under ~/.superego/run/<hash>/. Actions to restart, stop and
// show it; tools for the agent; and archiving a folder's last thread stops it.
import { createHash } from 'node:crypto'
import { writeFile, mkdir } from 'node:fs/promises'
import { join } from 'node:path'
import { StringDecoder } from 'node:string_decoder'
import {
  defineAction, defineDaemonExtension, defineExtension, defineTool, int, obj, opt, bool, str, section, spawnGroup, RpcError,
  type SpawnedGroup,
} from 'superego'
import { findConfig, howToAdd, shellArgs, DEFAULT_GRACE, type FoundConfig } from './config.ts'
import { LogFile, OutputBuffer, stripAnsi, tail } from './output.ts'
import { about, IDLE, LOGS_VIEW, OUTPUT, STATUS, type ConfigInfo, type OutputMark, type OutputSlice, type RunStatus } from './shared.ts'

type Runner = {
  folder: string
  /** Bumped by every restart and stop: a restart that finds it moved on leaves starting to the newer one. */
  generation: number
  group?: SpawnedGroup
  output: OutputBuffer
  log: LogFile
  /** Where the current (or last) run's output begins. */
  start: number
  /** The newest restart or stop, for those it overtook to answer with. */
  latest?: Promise<unknown>
  timer?: ReturnType<typeof setTimeout>
}

/** The folder's own directory under `<dataDir>/run`. */
export const folderKey = (folder: string) => createHash('sha256').update(folder).digest('hex').slice(0, 16)

const OUTPUT_EVERY = 100

export default defineDaemonExtension({
  ...about,
  setup(superego) {
    const status = superego.scopedValue<RunStatus>(STATUS, IDLE)
    const marks = superego.scopedValue<OutputMark>(OUTPUT, { end: 0, start: 0 })
    const runners = new Map<string, Runner>()
    const root = join(superego.dataDir, 'run')

    superego.settings.register({
      id: 'run', title: 'Run', description: "Each folder's dev command, from its .superego/run.json.",
      settings: [{
        key: 'run.command', title: 'Default command', default: '', type: { type: 'string', placeholder: 'e.g. just run' },
        description: 'Run where a folder has no .superego/run.json. Empty: none.',
      }],
    })

    function runnerOf(folder: string): Runner {
      let runner = runners.get(folder)
      if (!runner) {
        const dir = join(root, folderKey(folder))
        runner = { folder, generation: 0, output: new OutputBuffer(), log: new LogFile(join(dir, 'run.log')), start: 0 }
        runners.set(folder, runner)
        void mkdir(dir, { recursive: true }).then(() => writeFile(join(dir, 'folder'), `${folder}\n`)).catch(() => {})
      }
      return runner
    }

    /** The runner's state, the folder's config kept with it (the state and the config change apart). */
    const setStatus = (folder: string, next: RunStatus) => {
      const { config } = status.get(folder)
      status.set(folder, config ? { ...next, config } : next)
    }
    /** What a config says of itself, for the window and the agent. */
    const infoOf = (config: FoundConfig | undefined, folder: string): ConfigInfo => config
      ? { found: true, path: config.path, command: config.command, ...(config.ready ? { ready: config.ready } : {}) }
      : { found: false, error: howToAdd(folder) }
    /** Put the folder's config in its status, when it changed: watchers hear it. */
    function publishConfig(folder: string, info: ConfigInfo) {
      const now = status.get(folder)
      if (JSON.stringify(now.config) !== JSON.stringify(info)) status.set(folder, { ...now, config: info })
      return info
    }

    const publish = (runner: Runner) => marks.set(runner.folder, { end: runner.output.end, start: runner.start })
    /** Output changes the live value at most every 100ms, so watchers aren't flooded. */
    function schedule(runner: Runner) {
      if (runner.timer || superego.signal.aborted) return
      runner.timer = setTimeout(() => { runner.timer = undefined; publish(runner) }, OUTPUT_EVERY)
    }
    superego.signal.addEventListener('abort', () => { for (const r of runners.values()) clearTimeout(r.timer) })

    /** Output of the runner's own: a separator line, in memory and in the log. */
    function note(runner: Runner, line: string) {
      const text = `\n── ${line} · ${new Date().toISOString()} ──\n`
      runner.output.append(text)
      void runner.log.write(text)
      schedule(runner)
    }

    async function configOf(folder: string): Promise<FoundConfig | undefined> {
      const found = await findConfig(folder)
      if (found) return found
      const command = String(superego.settings.get<string>('run.command') ?? '').trim()
      return command ? { command, grace: DEFAULT_GRACE, env: {}, path: 'settings: run.command', dir: folder } : undefined
    }

    function start(runner: Runner, config: FoundConfig) {
      const shell = process.env.SHELL || '/bin/sh'
      const group = spawnGroup(shell, shellArgs(shell, config.command), {
        cwd: config.dir, env: { ...process.env, ...config.env }, stdio: ['pipe', 'pipe', 'pipe'],
        grace: config.grace, signal: superego.signal,
      })
      runner.group = group
      runner.start = runner.output.end
      const short = config.command.length > 72 ? `${config.command.slice(0, 71)}…` : config.command
      note(runner, `start: ${short}`)
      const startedAt = Date.now()
      const base = { command: config.command, ready: config.ready, pid: group.child.pid, startedAt }
      setStatus(runner.folder, { ...base, state: config.ready ? 'starting' : 'running' })
      publish(runner)

      // Ready once its text appears, even split across chunks or wrapped in colour.
      let seen = ''
      const ready = config.ready
      const take = (decoder: StringDecoder) => (chunk: Buffer) => {
        const text = decoder.write(chunk)
        if (!text) return
        runner.output.append(text)
        void runner.log.write(text)
        schedule(runner)
        if (ready && runner.group === group && status.get(runner.folder).state === 'starting') {
          seen = (seen + stripAnsi(text)).slice(-(ready.length + 4096))
          if (seen.includes(ready)) status.update(runner.folder, (s) => ({ ...s, state: 'running' }))
        }
      }
      group.child.stdout?.on('data', take(new StringDecoder('utf8')))
      group.child.stderr?.on('data', take(new StringDecoder('utf8')))
      group.child.stdin?.on('error', () => {})   // kept open, never written: some watchers quit when stdin closes

      void group.exited.then((exit) => {
        const how = exit.error ? `failed to start: ${exit.error.message}` : exit.stopped ? 'stopped'
          : exit.signal ? `killed by ${exit.signal}` : `exited with code ${exit.code}`
        note(runner, how)
        if (runner.group !== group) return
        runner.group = undefined
        const failed = !exit.stopped && (Boolean(exit.error) || exit.code !== 0)
        setStatus(runner.folder, {
          ...base, state: failed ? 'failed' : 'stopped', endedAt: Date.now(), exitCode: exit.code, signal: exit.signal,
          error: exit.error?.message,
        })
      })
    }

    /** Stop the folder's command, if it runs; resolves once all of it is gone. */
    function stop(folder: string): Promise<RunStatus> {
      const runner = runners.get(folder)
      if (!runner) return Promise.resolve(status.get(folder))
      runner.generation++
      const done = (async () => {
        await runner.group?.stop()
        await runner.log.flushed()
        return status.get(folder)
      })()
      runner.latest = done.catch(() => {})
      return done
    }

    /**
     * Stop it if it runs, then start it. Of restarts (and stops) that overlap, the newest decides: it alone starts it,
     * and those it overtook answer as it does.
     */
    function restart(folder: string): Promise<RunStatus> {
      const runner = runnerOf(folder)
      const generation = ++runner.generation
      const overtaken = async () => { await runner.latest; return status.get(folder) }
      const done = (async () => {
        const config = await configOf(folder).catch((error: Error) => {
          publishConfig(folder, { found: false, error: error.message })
          throw new RpcError('invalid_params', error.message)
        })
        publishConfig(folder, infoOf(config, folder))
        if (!config) throw new RpcError('not_found', howToAdd(folder), { hint: 'Add .superego/run.json, then restart.' })
        if (generation !== runner.generation) return overtaken()
        await runner.group?.stop()
        if (generation !== runner.generation) return overtaken()
        start(runner, config)
        return status.get(folder)
      })()
      runner.latest = done.catch(() => {})
      return done
    }

    function read(folder: string, since?: number): OutputSlice {
      const runner = runners.get(folder)
      if (!runner) return { text: '', from: 0, end: 0, start: 0 }
      const { text, from } = runner.output.read(since ?? runner.start)
      return { text, from, end: runner.output.end, start: runner.start }
    }

    /** Look for the folder's config again, and publish what's found in its status. */
    async function configInfo(folder: string): Promise<ConfigInfo> {
      const info = await configOf(folder).then((config) => infoOf(config, folder), (error: Error): ConfigInfo => ({ found: false, error: error.message }))
      return superego.signal.aborted ? info : publishConfig(folder, info)
    }
    const recheck = (folder: string) => void configInfo(folder).catch(() => {})

    // ── Actions: ⌘K, `superego do`, and the window's buttons ───────────────────────────────────────────────────────

    // A thread is `thread`, filled in by the window from the one shown; or a folder.
    const target = obj({
      thread: opt(str({ description: 'a thread: its folder' })),
      folder: opt(str({ description: 'a folder, instead of a thread' })),
    })
    async function folderOf({ thread, folder }: { thread?: string; folder?: string }) {
      if (folder) return folder
      if (!thread) throw new RpcError('invalid_params', 'Say which thread (--thread) or folder (--folder).')
      return (await superego.threads.get(thread)).cwd
    }

    superego.action(defineAction({
      id: 'run.restart', title: 'Restart the dev command', description: "Start this folder's dev command, or restart it if it runs.",
      expose: ['ui', 'cli'], thread: true, params: target,
      run: async (params) => restart(await folderOf(params)),
    }))
    superego.action(defineAction({
      id: 'run.stop', title: 'Stop the dev command', description: "Stop this folder's dev command.",
      expose: ['ui', 'cli'], thread: true, params: target,
      run: async (params) => stop(await folderOf(params)),
    }))
    superego.action(defineAction({
      id: 'run.logs', title: 'Show the dev command’s output', description: "Open the folder's dev command output beside the thread.",
      expose: ['ui', 'cli'], thread: true, params: obj({ thread: opt(str()) }),
      run: ({ thread }) => {
        if (!thread) throw new RpcError('invalid_params', 'Say which thread (--thread).')
        return superego.dispatch('pane.open', { thread, kind: LOGS_VIEW })
      },
    }))

    superego.method('run.read', async ({ folder, since }) => read(folder, since), { params: obj({ folder: str(), since: opt(int({ minimum: 0 })) }) })
    superego.method('run.config', ({ folder }) => configInfo(folder), { params: obj({ folder: str() }) })
    superego.method('run.status', ({ folder }) => status.get(folder), { params: obj({ folder: str() }) })

    // ── The agent ──────────────────────────────────────────────────────────────────────────────────────────────────

    const folderOfCall = async (conversationId: Parameters<typeof superego.threads.of>[0]) => (await superego.threads.get(superego.threads.of(conversationId)!)).cwd
    const text = (value: string) => ({ output: [{ type: 'text' as const, text: value }] })
    const describe = (folder: string, s: RunStatus) => {
      const parts = [`state: ${s.state}`]
      if (s.command) parts.push(`command: ${s.command}`)
      if (s.pid && (s.state === 'running' || s.state === 'starting')) parts.push(`pid: ${s.pid}`)
      if (s.startedAt) parts.push(`started: ${new Date(s.startedAt).toISOString()}`)
      if (s.endedAt) parts.push(`ended: ${new Date(s.endedAt).toISOString()}`, `exit code: ${s.exitCode ?? s.signal ?? '?'}`)
      if (s.state === 'starting' && s.ready) parts.push(`waiting for "${s.ready}" in its output`)
      if (s.error) parts.push(`error: ${s.error}`)
      return `${folder}\n${parts.join('\n')}`
    }

    superego.agent(defineExtension({
      name: 'run',
      tools: [
        defineTool({
          name: 'run_status', description: "The state of this folder's dev command (from .superego/run.json): idle, starting, running, stopped or failed, with its pid and exit code.",
          parameters: obj({}),
          async execute(_args, api) {
            const folder = await folderOfCall(api.conversationId)
            const s = status.get(folder)
            if (s.state === 'idle') {
              const info = await configInfo(folder)
              return text(info.found ? `${folder}\nstate: idle (not started). Command: ${info.command}` : info.error)
            }
            return text(describe(folder, s))
          },
        }),
        defineTool({
          name: 'run_logs', description: "The dev command's recent output, without colour codes: the last `lines` lines (default 100) of its current or last run, or of everything kept with `all`.",
          parameters: obj({
            lines: opt(int({ minimum: 1, maximum: 2000, description: 'how many lines, from the end (100)' })),
            all: opt(bool({ description: 'from before the last start too (as much as is kept)' })),
          }),
          async execute({ lines, all }, api) {
            const folder = await folderOfCall(api.conversationId)
            const slice = read(folder, all ? 0 : undefined)
            const s = status.get(folder)
            return text(`[${s.state}] ${folder}\n${tail(slice.text, lines ?? 100) || '(no output)'}`)
          },
        }),
        defineTool({
          name: 'run_restart', description: "Start this folder's dev command on this machine, or restart it if it runs. Answers once it has started (not necessarily ready: check run_status).",
          parameters: obj({}), executionMode: 'sequential',
          async execute(_args, api) {
            const folder = await folderOfCall(api.conversationId)
            try { return text(describe(folder, await restart(folder))) } catch (error) { throw new Error((error as Error).message) }
          },
        }),
        defineTool({
          name: 'run_stop', description: "Stop this folder's dev command and everything it started.",
          parameters: obj({}), executionMode: 'sequential',
          async execute(_args, api) {
            const folder = await folderOfCall(api.conversationId)
            return text(describe(folder, await stop(folder)))
          },
        }),
      ],
      sections: [section('run', () =>
        "This folder's long-running dev command (a server, a watcher) is managed by Superego from .superego/run.json, one per folder. "
        + "It runs on the machine you run on, so a server it starts is at this machine's localhost. "
        + "Don't start it yourself with bash: use run_status, run_logs (to read its errors after a change), run_restart and run_stop.")],
    }))

    // ── The config, kept current in each folder's status; a folder's last thread archived stops its command ─────────
    // The window asks too (run.config) as it shows a thread and comes back to the front; these keep it right meanwhile.
    void superego.threads.list().then((threads) => { for (const folder of new Set(threads.map((t) => t.cwd))) recheck(folder) }, () => {})

    superego.thread({
      started(thread) { recheck(thread.cwd) },
      turnStart(thread) { recheck(thread.cwd) },
      // In `archiving` rather than `archived`: other extensions' `archived` (a worktree's removal) runs first.
      async archiving(thread) {
        const runner = runners.get(thread.cwd)
        if (!runner?.group) return
        const others = (await superego.threads.list()).filter((t) => t.cwd === thread.cwd && t.id !== thread.id)
        if (others.length) return
        await stop(thread.cwd)
        return { note: 'stopped its dev command' }
      },
    })

    // Stopping goes with the signal (spawnGroup's): make sure the log has the end on it.
    return async () => { await Promise.all([...runners.values()].map((r) => r.group?.exited.then(() => r.log.flushed()))) }
  },
})
