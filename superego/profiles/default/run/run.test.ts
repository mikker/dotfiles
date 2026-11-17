// run, tested as it runs: a real daemon with this profile, threads in throwaway folders with a tiny .superego/run.json
// each, and real processes. Run with `superego extension test run --user`.
import { cp, mkdtemp, mkdir, readFile, readdir, rm, writeFile, stat } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { dirname, join, normalize } from 'node:path'
import { afterEach, beforeAll, describe, expect, it } from 'vitest'
import { callTool, isRunning, say, testDaemon, type TestDaemon } from 'superego/testing'
import { commandLine, findConfig, parseConfig, shellArgs } from './config.ts'
import { folderKey } from './daemon.ts'
import { LogFile, OutputBuffer, stripAnsi, tail } from './output.ts'
import { parseLine } from './ansi.ts'
import { OUTPUT, STATUS, type ConfigInfo, type OutputMark, type OutputSlice, type RunStatus } from './shared.ts'

// The profile this extension is in: copied for each test, so editing it there doesn't touch yours.
const profile = new URL('..', import.meta.url).pathname
// A plain shell, so the tests don't depend on (or wait for) the user's own shell setup.
beforeAll(() => { process.env.SHELL = '/bin/sh' })

let daemon: TestDaemon | undefined
const folders: string[] = []
afterEach(async () => {
  await daemon?.close()
  daemon = undefined
  await Promise.all(folders.splice(0).map((f) => rm(f, { recursive: true, force: true })))
})

async function folderWith(config: unknown): Promise<string> {
  const folder = await mkdtemp(join(tmpdir(), 'run-test-'))
  folders.push(folder)
  if (config !== undefined) {
    await mkdir(join(folder, '.superego'))
    await writeFile(join(folder, '.superego', 'run.json'), typeof config === 'string' ? config : JSON.stringify(config))
  }
  return folder
}

const TICKER = "echo booting; sleep 0.3; printf '\\033[32mSTATUS:\\033[0mREADY\\n'; while true; do echo tick; sleep 0.1; done"

async function start(config: unknown) {
  daemon ??= await testDaemon({ profile })
  const folder = await folderWith(config)
  const thread = await daemon.thread(undefined, { cwd: folder })
  const status = await daemon.watch<RunStatus>(STATUS, { scope: folder })
  return { daemon, folder, thread, status }
}

const output = (d: TestDaemon, folder: string, since = 0) => d.call<OutputSlice>('run.read', { folder, since })

describe('config', () => {
  it('reads commands as arrays or strings, with ready, grace and env', () => {
    expect(parseConfig('{"command":["just","run"],"ready":"STATUS:READY","grace":2}'))
      .toEqual({ command: 'just run', ready: 'STATUS:READY', grace: 2000, env: {} })
    expect(parseConfig('{"command":"npm run dev -- --port 3000","env":{"PORT":3000,"X":"y"}}'))
      .toEqual({ command: 'npm run dev -- --port 3000', ready: undefined, grace: 5000, env: { PORT: '3000', X: 'y' } })
    expect(commandLine(['echo', "it's", 'a b', '--x=1'])).toBe(`echo 'it'\\''s' 'a b' --x=1`)
    expect(shellArgs('/bin/zsh', 'just run')).toEqual(['-l', '-i', '-c', "set +m; trap 'exit 143' TERM; just run"])
    expect(shellArgs('/opt/homebrew/bin/fish', 'just run').at(-1)).toBe('status job-control none; just run')
  })

  it('says what is wrong', () => {
    expect(() => parseConfig('{')).toThrow(/isn't JSON/)
    expect(() => parseConfig('[]')).toThrow(/object/)
    expect(() => parseConfig('{"command":[]}')).toThrow(/command/)
    expect(() => parseConfig('{"command":"x","grace":"soon"}')).toThrow(/grace/)
    expect(() => parseConfig('{"command":"x","env":{"A":{}}}')).toThrow(/env.A/)
  })

  it('finds the nearest config up to the repository root', async () => {
    const root = await folderWith({ command: 'echo hi' })
    const deep = join(root, 'a', 'b')
    await mkdir(deep, { recursive: true })
    expect((await findConfig(deep))?.dir).toBe(root)
    await mkdir(join(root, 'a', '.git'))
    expect(await findConfig(deep)).toBeUndefined()
    await writeFile(join(root, '.superego', 'run.json'), '{"command": 3}')
    await expect(findConfig(root)).rejects.toThrow(/run.json "command"/)
  })
})

describe('output', () => {
  it('keeps the newest output by position', () => {
    const buffer = new OutputBuffer(100)
    buffer.append('a'.repeat(60))
    buffer.append('b'.repeat(60))
    expect(buffer.end).toBe(120)
    expect(buffer.from).toBeGreaterThan(0)
    const { text, from } = buffer.read(0)
    expect(from).toBe(buffer.from)
    expect(text.endsWith('b'.repeat(60))).toBe(true)
    expect(buffer.read(110).text).toBe('b'.repeat(10))
  })

  it('tails plain lines, escapes and redraws gone', () => {
    expect(stripAnsi('\u001b[1;31merror\u001b[0m')).toBe('error')
    expect(tail('one\ntwo\r50%\rdone\n\u001b[32mthree\u001b[0m\n', 2)).toBe('done\nthree')
    const { runs } = parseLine('\u001b[1;32mok\u001b[0m plain')
    expect(runs.map((r) => r.text)).toEqual(['ok', ' plain'])
    expect(runs[0]!.style).toMatchObject({ bold: true, fg: 'var(--run-c2)' })
  })

  it('rotates the log past its size', async () => {
    const folder = await folderWith(undefined)
    const log = new LogFile(join(folder, 'logs', 'run.log'), 100)
    for (let i = 0; i < 5; i++) void log.write(`${String(i).repeat(39)}\n`)
    await log.flushed()
    expect(await readFile(join(folder, 'logs', 'run.log.1'), 'utf8')).toBe(`${'2'.repeat(39)}\n${'3'.repeat(39)}\n`)
    expect(await readFile(join(folder, 'logs', 'run.log'), 'utf8')).toBe(`${'4'.repeat(39)}\n`)
  })
})

describe('the runner', () => {
  it('starts, waits for its ready text, and stops', async () => {
    const { daemon, folder, thread, status } = await start({ command: TICKER, ready: 'STATUS:READY', grace: 10 })
    await daemon.dispatch('run.restart', { thread: thread.id })
    await status.until((s) => s.state === 'starting', 'starting')
    const { pid } = await status.until((s) => s.state === 'running', 'ready')
    expect(isRunning(pid!)).toBe(true)
    expect((await output(daemon, folder)).text).toContain('booting')

    const marks = await daemon.watch<OutputMark>(OUTPUT, { scope: folder })
    await marks.until((m) => m.end > 0, 'output')

    const at = Date.now()
    await daemon.dispatch('run.stop', { thread: thread.id })
    expect(Date.now() - at).toBeLessThan(2000)   // SIGTERM was enough: not the grace's SIGKILL
    expect(status.value.state).toBe('stopped')
    expect(isRunning(pid!)).toBe(false)

    // The log has it all, between separators.
    const log = await readFile(join(daemon.dataDir, 'run', folderKey(folder), 'run.log'), 'utf8')
    expect(log).toMatch(/── start: echo booting/)
    expect(log).toContain('tick')
    expect(log).toMatch(/── stopped/)
  })

  it('is running at once without ready text, and failed on a non-zero exit', async () => {
    const { daemon, folder, thread, status } = await start({ command: 'echo up; sleep 0.5; echo bad >&2; exit 3' })
    await daemon.dispatch('run.restart', { folder })
    expect(status.value.state).toBe('running')
    const failed = await status.until((s) => s.state === 'failed', 'failed')
    expect(failed.exitCode).toBe(3)
    expect((await output(daemon, folder)).text).toContain('bad')
    expect(thread.cwd).toBe(folder)
  })

  it('says how to add a config when there is none', async () => {
    const { daemon, thread } = await start(undefined)
    await expect(daemon.dispatch('run.restart', { thread: thread.id })).rejects.toThrow(/\.superego\/run\.json/)
  })

  it('collapses overlapping restarts: the newest starts it, once', async () => {
    const { daemon, folder, thread, status } = await start({ command: 'echo up; sleep 30' })
    await Promise.all([1, 2, 3].map(() => daemon.dispatch('run.restart', { thread: thread.id })))
    const starts = () => output(daemon, folder).then((o) => o.text.match(/── start:/g)?.length ?? 0)
    expect(await starts()).toBe(1)
    const first = status.value.pid!

    const answers = await Promise.all([1, 2, 3].map(() => daemon.dispatch<RunStatus>('run.restart', { thread: thread.id })))
    // Each answers with the one that started.
    expect(new Set(answers.map((a) => a.pid))).toEqual(new Set([status.value.pid]))
    const all = (await output(daemon, folder, 0)).text
    expect(all.match(/── start:/g)?.length).toBe(2)
    expect(isRunning(first)).toBe(false)
    expect(status.value.state).toBe('running')
    expect(isRunning(status.value.pid!)).toBe(true)
    await daemon.dispatch('run.stop', { thread: thread.id })
  })

  it('kills what ignores SIGTERM after the grace, children too', async () => {
    const { daemon, folder, thread, status } = await start({ command: "trap '' TERM; sleep 60 & echo child $!; while true; do sleep 0.1; done", grace: 0.5 })
    await daemon.dispatch('run.restart', { thread: thread.id })
    let child = 0
    await daemon.until(async () => {
      child = Number(/child (\d+)/.exec((await output(daemon, folder)).text)?.[1] ?? 0)
      return child > 0
    }, 'the child')
    const at = Date.now()
    await daemon.dispatch('run.stop', { thread: thread.id })
    expect(Date.now() - at).toBeGreaterThanOrEqual(400)
    expect(status.value.state).toBe('stopped')
    expect(isRunning(status.value.pid!)).toBe(false)
    expect(isRunning(child)).toBe(false)
  })

  it("stops when its folder's last thread is archived", async () => {
    const { daemon, folder, thread, status } = await start({ command: 'sleep 30' })
    const other = await daemon.thread(undefined, { cwd: folder })
    await daemon.dispatch('run.restart', { thread: thread.id })
    const { pid } = status.value
    await daemon.dispatch('thread.archive', { thread: thread.id })
    expect(status.value.state).toBe('running')
    await daemon.dispatch('thread.archive', { thread: other.id })
    expect(status.value.state).toBe('stopped')
    expect(isRunning(pid!)).toBe(false)
  })
})

describe('the agent', () => {
  it('restarts, reads its status and its logs', async () => {
    const folder = await folderWith({ command: "echo hello from the server; echo 'Error: boom' >&2; sleep 30" })
    daemon = await testDaemon({
      profile,
      model: [callTool('run_restart'), callTool('run_status'), callTool('run_logs', { lines: 5 }), callTool('run_stop'), say('Done.')],
    })
    const thread = await daemon.thread('Check the server', { cwd: folder })
    const transcript = await daemon.transcript(thread.id)
    expect(transcript).toContain('state: running')
    expect(transcript).toContain('Error: boom')
    expect(transcript).toContain('state: stopped')
    expect(transcript).toContain('Done.')
  })

  it('tells the agent how to add a config', async () => {
    const folder = await folderWith(undefined)
    daemon = await testDaemon({ profile, model: [callTool('run_status'), say('ok')] })
    const thread = await daemon.thread('Status?', { cwd: folder })
    expect(await daemon.transcript(thread.id)).toContain('.superego/run.json')
  })
})

describe('the config in the status', () => {
  it('says there is one before anything runs, and keeps it through runs', async () => {
    const { daemon, folder, thread, status } = await start({ command: 'echo hi' })
    // Looked at as the thread was made: an idle folder with a config is one the window shows Run for.
    const idle = await status.until((s) => Boolean(s.config), 'the config looked at')
    expect(idle).toMatchObject({ state: 'idle', config: { found: true, command: 'echo hi' } })
    await daemon.dispatch('run.restart', { thread: thread.id })
    const stopped = await status.until((s) => s.state === 'stopped', 'exit 0')
    expect(stopped.config).toMatchObject({ found: true, command: 'echo hi' })
    expect(thread.cwd).toBe(folder)
  })

  it('finds one added later: as the window asks, and as a turn starts', async () => {
    daemon = await testDaemon({ profile, model: [say('ok')] })
    const folder = await folderWith(undefined)
    const thread = await daemon.thread(undefined, { cwd: folder })
    const status = await daemon.watch<RunStatus>(STATUS, { scope: folder })
    await status.until((s) => s.config?.found === false, 'none at first')

    // The window asks (it shows the thread, or comes back to the front).
    await mkdir(join(folder, '.superego'))
    await writeFile(join(folder, '.superego', 'run.json'), '{"command": "just run"}')
    expect(await daemon.call<ConfigInfo>('run.config', { folder })).toMatchObject({ found: true, command: 'just run' })
    await status.until((s) => s.config?.found === true, 'found as asked')

    // A turn looks again: a broken one says so.
    await writeFile(join(folder, '.superego', 'run.json'), '{"command": 3}')
    await daemon.send(thread.id, 'go')
    const broken = await status.until((s) => s.config?.found === false, 'looked at as the turn started')
    expect(broken.config).toMatchObject({ error: expect.stringMatching(/"command"/) })
  })
})

// The window loads a profile's UI from inside that profile's folder only (`profile.module` refuses any other path), unlike
// its daemon extensions. A profile that lists run's UI as `../default/run/ui.tsx` has its whole UI refused, so its threads
// get no pill (nor anything else of its UI): it lists it through a folder of its own (a symlink to this one).
describe('the profiles that list run', () => {
  it("serve its UI, and every module it imports, as the window loads them", async () => {
    const root = dirname(profile)
    const dataDir = await mkdtemp(join(tmpdir(), 'run-profiles-'))
    folders.push(dataDir)
    // Your profiles as they are, links kept, as this machine's.
    await cp(root, join(dataDir, 'profiles'), { recursive: true, verbatimSymlinks: true, filter: (src) => !/(^|\/)node_modules$/.test(src) })
    daemon = await testDaemon({ dataDir, profile: join(dataDir, 'profiles', 'default') })
    const listing: string[] = []
    for (const name of await readdir(join(dataDir, 'profiles'))) {
      const ref = { scope: 'user', name, dir: join(dataDir, 'profiles', name) }
      const text = await readFile(join(ref.dir, 'profile.ts'), 'utf8').catch(() => '')
      if (!/run\/(ui|daemon)\.tsx?/.test(text)) continue
      listing.push(name)
      const { entries } = await daemon.call<{ entries: string[] }>('profile.ui', ref)
      expect(entries.some((e) => /run\/ui\.tsx$/.test(e)), `${name} lists run's UI`).toBe(true)
      // Each module, then what it imports by a relative path, as the window resolves them.
      const queue = [...entries]
      const seen = new Set<string>()
      while (queue.length) {
        const path = queue.shift()!
        if (seen.has(path)) continue
        seen.add(path)
        const module = await daemon.call<{ path: string; code: string }>('profile.module', { ...ref, path })
          .catch((error: Error) => { throw new Error(`${name}: ${path}: ${error.message}`) })
        for (const [, spec] of module.code.matchAll(/(?:from|import)\s*['"](\.{1,2}\/[^'"]+)['"]/g)) queue.push(normalize(join(dirname(module.path), spec!)))
      }
    }
    expect(listing).toContain('default')
  })
})

describe('the log folder', () => {
  it('names the folder it is for', async () => {
    const { daemon, folder, thread, status } = await start({ command: 'echo hi' })
    await daemon.dispatch('run.restart', { thread: thread.id })
    await status.until((s) => s.state === 'stopped', 'exit 0')
    const dir = join(daemon.dataDir, 'run', folderKey(folder))
    await daemon.until(async () => (await readdir(dir)).includes('folder'), 'the folder file')
    expect((await readFile(join(dir, 'folder'), 'utf8')).trim()).toBe(folder)
    expect((await stat(join(dir, 'run.log'))).size).toBeGreaterThan(0)
  })
})
