// A runner's output: the newest part kept in memory, by position in everything it ever wrote, and all of it appended
// to a log file that rotates.
import { appendFile, mkdir, rename, stat } from 'node:fs/promises'
import { dirname } from 'node:path'

/** About 1 MB of output kept in memory per folder. */
export const KEEP = 1024 * 1024
/** The log file rotates to `<file>.1` past this. */
export const ROTATE_AT = 2 * 1024 * 1024

/**
 * Output kept by position: `end` is how much was ever written, and the newest `keep` characters or so are held. Trims in
 * steps (to three quarters), so appending stays cheap.
 */
export class OutputBuffer {
  private held = ''
  end = 0
  private readonly keep: number
  constructor(keep = KEEP) { this.keep = keep }

  /** Where what's held begins. */
  get from() { return this.end - this.held.length }

  append(text: string) {
    this.held += text
    this.end += text.length
    if (this.held.length > this.keep) this.held = this.held.slice(this.held.length - Math.floor(this.keep * 0.75))
  }

  /** What's held from `since` on (from what's held, if that's gone). */
  read(since = 0): { text: string; from: number } {
    const from = Math.min(Math.max(since, this.from), this.end)
    return { text: this.held.slice(from - this.from), from }
  }
}

/** Appends to a file, one write at a time, moving it to `<file>.1` once it would pass `rotateAt` bytes. */
export class LogFile {
  private size: number | undefined
  private queue: Promise<void> = Promise.resolve()
  readonly path: string
  private readonly rotateAt: number
  constructor(path: string, rotateAt = ROTATE_AT) { this.path = path; this.rotateAt = rotateAt }

  write(text: string): Promise<void> {
    const bytes = Buffer.byteLength(text)
    this.queue = this.queue.then(async () => {
      if (this.size === undefined) {
        await mkdir(dirname(this.path), { recursive: true })
        this.size = await stat(this.path).then((s) => s.size, () => 0)
      }
      if (this.size > 0 && this.size + bytes > this.rotateAt) {
        await rename(this.path, `${this.path}.1`)
        this.size = 0
      }
      await appendFile(this.path, text)
      this.size += bytes
    }).catch((error: Error) => { this.size = undefined; console.error(`run: couldn't write ${this.path}: ${error.message}`) })
    return this.queue
  }

  /** Once everything written so far is on disk. */
  flushed() { return this.queue }
}

// SGR, cursor and other CSI sequences, OSC (titles, links) and lone escapes.
// eslint-disable-next-line no-control-regex
const ANSI = /\u001b\[[0-?]*[ -/]*[@-~]|\u001b\][^\u0007\u001b]*(?:\u0007|\u001b\\)|\u001b[@-Z\\-_]/g

/** Text without terminal escapes. */
export const stripAnsi = (text: string) => text.replace(ANSI, '')

/** Plain lines as a terminal would leave them: escapes gone, and a line redrawn with `\r` only its last drawing. */
export function plainLines(text: string): string[] {
  return stripAnsi(text).split('\n').map((line) => {
    const parts = line.replace(/\r$/, '').split('\r')
    return parts[parts.length - 1]!
  })
}

/** The last `count` lines of `text`, without escapes. */
export function tail(text: string, count: number): string {
  const lines = plainLines(text)
  if (lines.at(-1) === '') lines.pop()
  return lines.slice(-count).join('\n')
}
