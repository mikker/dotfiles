// Terminal output as styled runs: SGR colours and weights kept, every other escape dropped, and a line redrawn with
// `\r` shown as its last drawing.

export type Style = { fg?: string; bg?: string; bold?: boolean; dim?: boolean; italic?: boolean; underline?: boolean; inverse?: boolean }
export type Run = { text: string; style: Style }

/** The 16 colours, by index: CSS variables the stylesheet sets for light and dark. */
const basic = (n: number) => `var(--run-c${n})`

/** An xterm 256-colour index as CSS. */
function indexed(n: number): string {
  if (n < 16) return basic(n)
  if (n < 232) {
    const v = n - 16
    const level = (c: number) => c === 0 ? 0 : 55 + c * 40
    return `rgb(${level(Math.floor(v / 36))}, ${level(Math.floor(v / 6) % 6)}, ${level(v % 6)})`
  }
  const g = 8 + (n - 232) * 10
  return `rgb(${g}, ${g}, ${g})`
}

function apply(style: Style, params: number[]): Style {
  const next = { ...style }
  for (let i = 0; i < params.length; i++) {
    const p = params[i]!
    if (p === 0) for (const key of Object.keys(next) as (keyof Style)[]) delete next[key]
    else if (p === 1) next.bold = true
    else if (p === 2) next.dim = true
    else if (p === 3) next.italic = true
    else if (p === 4) next.underline = true
    else if (p === 7) next.inverse = true
    else if (p === 22) { delete next.bold; delete next.dim }
    else if (p === 23) delete next.italic
    else if (p === 24) delete next.underline
    else if (p === 27) delete next.inverse
    else if (p >= 30 && p <= 37) next.fg = basic(p - 30)
    else if (p === 39) delete next.fg
    else if (p >= 40 && p <= 47) next.bg = basic(p - 40)
    else if (p === 49) delete next.bg
    else if (p >= 90 && p <= 97) next.fg = basic(p - 90 + 8)
    else if (p >= 100 && p <= 107) next.bg = basic(p - 100 + 8)
    else if (p === 38 || p === 48) {
      const key = p === 38 ? 'fg' : 'bg'
      if (params[i + 1] === 5 && params[i + 2] !== undefined) { next[key] = indexed(params[i + 2]!); i += 2 }
      else if (params[i + 1] === 2 && params[i + 4] !== undefined) { next[key] = `rgb(${params[i + 2]}, ${params[i + 3]}, ${params[i + 4]})`; i += 4 }
    }
  }
  return next
}

// eslint-disable-next-line no-control-regex
const ESCAPE = /\u001b\[([0-?]*)([ -/]*)([@-~])|\u001b\][^\u0007\u001b]*(?:\u0007|\u001b\\)|\u001b[@-Z\\-_]/g

/** One line (no `\n`) as runs, starting in `style`; and the style it leaves for the next line. */
export function parseLine(line: string, style: Style = {}): { runs: Run[]; style: Style } {
  // A redrawn line (a progress bar): only what was drawn after the last carriage return.
  const cr = line.replace(/\r$/, '').lastIndexOf('\r')
  const visible = cr >= 0 ? line.slice(cr + 1) : line
  const runs: Run[] = []
  let at = 0
  let current = style
  const push = (text: string) => {
    if (!text) return
    const last = runs.at(-1)
    if (last && last.style === current) last.text += text
    else runs.push({ text, style: current })
  }
  for (const match of visible.matchAll(ESCAPE)) {
    push(visible.slice(at, match.index))
    at = match.index! + match[0].length
    if (match[3] === 'm' && !match[2]) current = apply(current, (match[1] || '0').split(/[;:]/).map((n) => Number(n) || 0))
  }
  push(visible.slice(at).replace(/\r$/, ''))
  return { runs, style: current }
}

/** Text as lines of runs, the style carried from one line to the next. */
export function parseLines(text: string): Run[][] {
  let style: Style = {}
  return text.split('\n').map((line) => {
    const parsed = parseLine(line, style)
    style = parsed.style
    return parsed.runs
  })
}
