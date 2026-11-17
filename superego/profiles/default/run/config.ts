// A folder's run config: `.superego/run.json`, in the folder or the nearest folder above it up to the repository's
// root. `{ "command": ["just", "run"], "ready": "STATUS:READY", "grace": 5, "env": { "PORT": "3000" } }`.
import { readFile, stat } from 'node:fs/promises'
import { dirname, join } from 'node:path'

export const CONFIG_FILE = join('.superego', 'run.json')

export type RunConfig = {
  /** The shell command line to run. */
  command: string
  /** Text in the output that marks it ready. */
  ready?: string
  /** Milliseconds between SIGTERM and SIGKILL. */
  grace: number
  env: Record<string, string>
}

export const DEFAULT_GRACE = 5000

/** A config as read: where it came from, and the folder the command runs in (the one holding `.superego`). */
export type FoundConfig = RunConfig & { path: string; dir: string }

/** Why there's no config, in words the user can act on. */
export const howToAdd = (folder: string) =>
  `No run config for ${folder}. Add ${CONFIG_FILE} to the project, e.g. {"command": ["npm", "run", "dev"], "ready": "ready in"}.`

/** A config from its JSON text; throws with what's wrong. */
export function parseConfig(text: string): RunConfig {
  let data: unknown
  try { data = JSON.parse(text) } catch (error) { throw new Error(`isn't JSON: ${(error as Error).message}`) }
  if (!data || typeof data !== 'object' || Array.isArray(data)) throw new Error('should be an object with a "command"')
  const { command, ready, grace, env } = data as Record<string, unknown>
  return {
    command: commandLine(command),
    ready: ready === undefined || ready === null || ready === '' ? undefined : typeof ready === 'string' ? ready : fail('"ready" should be a string'),
    grace: grace === undefined ? DEFAULT_GRACE
      : typeof grace === 'number' && grace >= 0 && Number.isFinite(grace) ? Math.round(grace * 1000) : fail('"grace" should be a number of seconds'),
    env: env === undefined ? {} : envOf(env),
  }
}

function fail(message: string): never { throw new Error(message) }

/** A command as a shell line: a string as it is, an argv array quoted where it needs to be. */
export function commandLine(command: unknown): string {
  if (typeof command === 'string' && command.trim()) return command.trim()
  if (Array.isArray(command) && command.length && command.every((part) => typeof part === 'string') && command[0]) {
    return command.map(quote).join(' ')
  }
  return fail('"command" should be a string or a non-empty array of strings')
}

// Bare words stay bare, so the first can still be one of the shell's aliases.
const quote = (word: string) => /^[\w@%+=:,./-]+$/.test(word) ? word : `'${word.replaceAll("'", `'\\''`)}'`

function envOf(env: unknown): Record<string, string> {
  if (!env || typeof env !== 'object' || Array.isArray(env)) fail('"env" should be an object of strings')
  const out: Record<string, string> = {}
  for (const [key, value] of Object.entries(env as Record<string, unknown>)) {
    if (typeof value === 'string') out[key] = value
    else if (typeof value === 'number' || typeof value === 'boolean') out[key] = String(value)
    else fail(`"env.${key}" should be a string`)
  }
  return out
}

const exists = (path: string) => stat(path).then(() => true, () => false)

/**
 * The config for `folder`: its own `.superego/run.json`, else the nearest above it, stopping at the repository's root
 * (a folder with `.git`). Undefined when there's none; throws when one is there but wrong.
 */
export async function findConfig(folder: string): Promise<FoundConfig | undefined> {
  for (let dir = folder; ; dir = dirname(dir)) {
    const path = join(dir, CONFIG_FILE)
    const text = await readFile(path, 'utf8').catch(() => undefined)
    if (text !== undefined) {
      try { return { ...parseConfig(text), path, dir } } catch (error) { throw new Error(`${path} ${(error as Error).message}`) }
    }
    if (dirname(dir) === dir || await exists(join(dir, '.git'))) return undefined
  }
}

/**
 * How to run `command` in `shell`: as a login and interactive shell, so the user's PATH and aliases are there as in
 * their terminal; with job control off, so what it starts in the background stays in its process group (and stops
 * with it); and ending on SIGTERM, which an interactive shell otherwise ignores (a loop would last till the SIGKILL).
 */
export function shellArgs(shell: string, command: string): string[] {
  const name = shell.split('/').pop() ?? ''
  const off = name === 'fish' ? 'status job-control none; ' : /^(ba|z|k|da|mk)?sh$/.test(name) ? "set +m; trap 'exit 143' TERM; " : ''
  return ['-l', '-i', '-c', `${off}${command}`]
}
