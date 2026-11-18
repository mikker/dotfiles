// What run is, for both halves (spread into each), and the names and shapes they share.

/** A folder's runner, as a live value scoped by the folder (a thread's `cwd`). */
export const STATUS = 'run.status'
/** How much output a folder's runner has written, scoped by folder: changes as output arrives (throttled). */
export const OUTPUT = 'run.output'
/** The logs view: a pane kind of the same id. */
export const LOGS_VIEW = 'run.logs-pane'

export const about = {
  name: 'run', version: '1.0.0', api: '^4', title: 'Run',
  panes: { [LOGS_VIEW]: "the output of this folder's dev command (run), live; no params" },
}

export type RunState = 'idle' | 'starting' | 'running' | 'stopped' | 'failed'

export type RunStatus = {
  state: RunState
  /** The command as run, in the shell. */
  command?: string
  /** The text that marks it ready, when there is one. */
  ready?: string
  pid?: number
  startedAt?: number
  endedAt?: number
  exitCode?: number | null
  signal?: string | null
  /** Why it couldn't start, or ended oddly. */
  error?: string
  /**
   * The folder's config as last looked at: whether there is one (so an idle folder with one shows Run), and what it
   * runs. Looked at again as a thread there starts or runs a turn, as the window shows it or comes back to the front
   * (`run.config`), and on every start. Absent until first looked at.
   */
  config?: ConfigInfo
}

/** Where the output stands: `end` grows as output arrives; `start` is where the current (or last) run began. */
export type OutputMark = { end: number; start: number }

/** A slice of a folder's output, from `run.read`. */
export type OutputSlice = {
  text: string
  /** Where `text` starts. Later than asked for when that part was already dropped from memory. */
  from: number
  end: number
  /** Where the current (or last) run's output begins. */
  start: number
}

/** What `run.config` says of a folder. */
export type ConfigInfo = { found: true; path: string; command: string; ready?: string } | { found: false; error: string }

export const IDLE: RunStatus = { state: 'idle' }
