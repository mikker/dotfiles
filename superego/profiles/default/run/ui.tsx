// run, UI half: the folder's dev command as a pill in the thread's header (click: its output), a dot on the thread's
// row in the sidebar while it runs (or failed), and its output as a pane: a live tail with colours, following the end
// until you scroll up, with Restart and Stop.
import { memo, useCallback, useEffect, useLayoutEffect, useRef, useState, type CSSProperties } from 'react'
import {
  ArrowClockwiseIcon, ArrowDownIcon, StopIcon, TerminalIcon, call, defineUiExtension, has, PaneMessage, ThreadBadge, useDispatch,
  useShortcut, useValue,
  type MachineEntry, type SlotProps, type ThreadInfo, type ViewProps,
} from 'superego/ui'
import { parseLine, type Run, type Style } from './ansi.ts'
import { about, LOGS_VIEW, OUTPUT, STATUS, type OutputMark, type OutputSlice, type RunState, type RunStatus } from './shared.ts'

const RUNNING_STATES: RunState[] = ['starting', 'running']
const LABEL: Record<RunState, string> = { idle: 'Run', starting: 'Starting', running: 'Running', stopped: 'Stopped', failed: 'Failed' }

const usable = (machine: MachineEntry) => machine.state === 'connected' && has(machine, 'ext:run')
const useStatus = (machine: MachineEntry, thread: ThreadInfo) => useValue<RunStatus>(machine, STATUS, { scope: thread.cwd }) ?? undefined

/**
 * Have the daemon look for the folder's run.json again (it puts what it finds in the status): as the thread is shown,
 * as it moves on, and as the window comes back to the front, so a config added meanwhile shows without a reload.
 */
function useConfigCheck(machine: MachineEntry, thread: ThreadInfo) {
  const ok = usable(machine)
  useEffect(() => {
    if (!ok) return
    const check = () => void call(machine.id, 'run.config', { folder: thread.cwd }).catch((error: Error) => console.debug(`run: ${error.message}`))
    const shown = () => { if (document.visibilityState === 'visible') check() }
    check()
    window.addEventListener('focus', check)
    document.addEventListener('visibilitychange', shown)
    return () => { window.removeEventListener('focus', check); document.removeEventListener('visibilitychange', shown) }
  }, [ok, machine.id, thread.cwd, thread.activeAt])
}

function useRunDispatch(machine: MachineEntry, thread: ThreadInfo) {
  const dispatch = useDispatch()
  return useCallback((id: string) => void dispatch(id, { thread: thread.id }, { machine: machine.id }).catch((error: Error) => console.error(`run: ${error.message}`)),
    [dispatch, machine.id, thread.id])
}

function since(at: number | undefined) {
  if (!at) return ''
  const s = Math.round((Date.now() - at) / 1000)
  return s < 60 ? `${s}s` : s < 3600 ? `${Math.round(s / 60)}m` : `${Math.round(s / 3600)}h`
}

function describe(s: RunStatus | undefined) {
  const config = s?.config
  if (!s || s.state === 'idle') return config?.found ? `${config.command}: not running` : 'No run config'
  const parts = [s.command ?? '']
  if (RUNNING_STATES.includes(s.state)) parts.push(`pid ${s.pid}`, `up ${since(s.startedAt)}`)
  if (s.state === 'starting' && s.ready) parts.push(`waiting for “${s.ready}”`)
  if (s.state === 'failed' || s.state === 'stopped') parts.push(s.error ?? (s.signal ? `killed by ${s.signal}` : `exit ${s.exitCode}`))
  return parts.filter(Boolean).join(' · ')
}

// ── The header pill ──────────────────────────────────────────────────────────────────────────────────────────────────

function Pill({ machine, thread }: ViewProps<'thread'>) {
  const status = useStatus(machine, thread)
  useConfigCheck(machine, thread)
  const act = useRunDispatch(machine, thread)
  const restartKeys = useShortcut('run.restart')
  if (!usable(machine)) return null
  const state = status?.state ?? 'idle'
  // Idle, it shows where there's a config to run: Run, to start it from its pane.
  if (state === 'idle' && !status?.config?.found) return null
  const label = state === 'failed' && typeof status?.exitCode === 'number' ? `Failed (${status.exitCode})` : LABEL[state]
  return (
    <button type="button" className={`run-pill is-${state}`} onClick={() => act('run.logs')}
      title={`${describe(status)}\nClick for its output${restartKeys ? ` · ${restartKeys} restarts` : ''}`}>
      <span className="run-dot" aria-hidden />{label}
    </button>
  )
}

// ── The sidebar mark ─────────────────────────────────────────────────────────────────────────────────────────────────

function Mark({ machine, thread }: SlotProps['thread.badge']) {
  const status = useStatus(machine, thread)
  if (!usable(machine) || !status || !['starting', 'running', 'failed'].includes(status.state)) return null
  return (
    <ThreadBadge label={`dev command ${status.state}`} title={`${LABEL[status.state]}: ${status.command ?? ''}`}>
      <TerminalIcon className={`run-mark is-${status.state}`} size={12} weight="bold" aria-hidden />
    </ThreadBadge>
  )
}

// ── The output pane ──────────────────────────────────────────────────────────────────────────────────────────────────

const MAX_LINES = 5000

/** Output as lines of runs, built as it arrives: whole lines parsed once, the line still being written kept raw. */
type Tail = { lines: Run[][]; dropped: number; pending: string; style: Style; have: number | undefined }
const emptyTail = (): Tail => ({ lines: [], dropped: 0, pending: '', style: {}, have: undefined })

function append(tail: Tail, text: string) {
  const parts = (tail.pending + text).split('\n')
  tail.pending = parts.pop()!
  for (const line of parts) {
    const parsed = parseLine(line, tail.style)
    tail.style = parsed.style
    tail.lines.push(parsed.runs)
  }
  if (tail.lines.length > MAX_LINES * 1.2) {
    const drop = tail.lines.length - MAX_LINES
    tail.lines.splice(0, drop)
    tail.dropped += drop
  }
}

const css = (style: Style): CSSProperties | undefined => {
  if (!style.fg && !style.bg && !style.bold && !style.dim && !style.italic && !style.underline && !style.inverse) return undefined
  const [fg, bg] = style.inverse ? [style.bg ?? 'var(--superego-bg)', style.fg ?? 'var(--superego-text)'] : [style.fg, style.bg]
  return { color: fg, background: bg, fontWeight: style.bold ? 600 : undefined, opacity: style.dim ? 0.65 : undefined,
    fontStyle: style.italic ? 'italic' : undefined, textDecoration: style.underline ? 'underline' : undefined }
}

const Line = memo(function Line({ runs }: { runs: Run[] }) {
  return <div className="run-line">{runs.length ? runs.map((run, i) => <span key={i} style={css(run.style)}>{run.text}</span>) : '\u200b'}</div>
})

function Logs({ machine, thread }: ViewProps<'thread'>) {
  const ok = usable(machine)
  const folder = thread.cwd
  const status = useStatus(machine, thread)
  const mark = useValue<OutputMark>(machine, OUTPUT, { scope: folder })
  useConfigCheck(machine, thread)
  const config = status?.config
  const act = useRunDispatch(machine, thread)
  const restartKeys = useShortcut('run.restart')

  const tail = useRef<Tail>(emptyTail())
  const [, redraw] = useState(0)
  const busy = useRef(false)
  const mounted = useRef(true)
  const latest = useRef(0)
  latest.current = mark?.end ?? 0
  const source = `${machine.id}\n${folder}`
  const current = useRef(source)
  current.current = source

  // Another folder or machine: start over.
  useEffect(() => { tail.current = emptyTail(); redraw((n) => n + 1) }, [source])
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])

  // Pull what's new whenever the end moves, one request at a time, until caught up with the newest end.
  useEffect(() => {
    if (!ok || !mark || busy.current) return
    busy.current = true
    void (async () => {
      try {
        while (mounted.current) {
          // The daemon started over (reloaded): so do we.
          if (tail.current.have !== undefined && latest.current < tail.current.have) tail.current = emptyTail()
          const t = tail.current
          const since = t.have ?? 0
          if (t.have !== undefined && latest.current <= since) break
          const asked = current.current
          const [machineId, from] = asked.split('\n') as [string, string]
          const slice = await call<OutputSlice>(machineId, 'run.read', { folder: from, since })
          if (!mounted.current) break
          if (asked !== current.current || t !== tail.current) continue
          if (slice.from > since && t.have !== undefined) append(t, '\n… (older output dropped)\n')
          append(t, slice.text)
          t.have = slice.end
          redraw((n) => n + 1)
          if (slice.end >= latest.current) break
        }
      } catch (error) {
        console.error(`run: ${(error as Error).message}`)
      } finally {
        busy.current = false
      }
    })()
  }, [ok, mark?.end, source])

  // Follow the end, until scrolled up from it.
  const scroller = useRef<HTMLDivElement>(null)
  const [following, setFollowing] = useState(true)
  const onScroll = () => {
    const el = scroller.current
    if (el) setFollowing(el.scrollTop + el.clientHeight >= el.scrollHeight - 24)
  }
  useLayoutEffect(() => {
    const el = scroller.current
    if (el && following) el.scrollTop = el.scrollHeight
  })
  const follow = () => {
    const el = scroller.current
    if (el) el.scrollTop = el.scrollHeight
    setFollowing(true)
  }

  if (!has(machine, 'ext:run')) return <PaneMessage>Run isn't set up on {machine.label}.</PaneMessage>
  if (machine.state !== 'connected') return <PaneMessage>{machine.label} is offline.</PaneMessage>

  const state = status?.state ?? 'idle'
  const t = tail.current
  const pending = t.pending ? parseLine(t.pending, t.style).runs : undefined
  const empty = !t.lines.length && !t.pending
  return (
    <div className="run-logs">
      <div className="run-logs__bar">
        <span className={`run-pill is-${state} is-static`} title={describe(status)}><span className="run-dot" aria-hidden />{LABEL[state] === 'Run' ? 'Idle' : LABEL[state]}</span>
        <span className="run-logs__command" title={config?.found ? config.path : undefined}>{status?.command ?? (config?.found ? config.command : '')}</span>
        <button type="button" className="run-button" disabled={!config?.found && state === 'idle'} onClick={() => act('run.restart')}
          title={`${RUNNING_STATES.includes(state) ? 'Restart' : 'Start'}${restartKeys ? ` (${restartKeys})` : ''}`}>
          <ArrowClockwiseIcon size={13} aria-hidden />{RUNNING_STATES.includes(state) ? 'Restart' : 'Start'}
        </button>
        <button type="button" className="run-button" disabled={!RUNNING_STATES.includes(state)} onClick={() => act('run.stop')} title="Stop">
          <StopIcon size={13} aria-hidden />Stop
        </button>
      </div>
      {empty && config && !config.found ? (
        <PaneMessage><div className="run-logs__empty"><TerminalIcon size={20} aria-hidden /><p>{config.error}</p></div></PaneMessage>
      ) : empty ? (
        <PaneMessage>{state === 'idle' ? `Not started.${restartKeys ? ` ${restartKeys} starts it.` : ''}` : 'No output yet.'}</PaneMessage>
      ) : (
        <div className="run-logs__output" ref={scroller} onScroll={onScroll}>
          {t.lines.map((runs, i) => <Line key={t.dropped + i} runs={runs} />)}
          {pending && <Line runs={pending} />}
        </div>
      )}
      {!following && !empty && (
        <button type="button" className="run-follow" onClick={follow}><ArrowDownIcon size={12} aria-hidden />Follow</button>
      )}
    </div>
  )
}

// ── Styles: the window's tokens, so light and dark both work ─────────────────────────────────────────────────────────

const STYLES = `
.run-pill { display: inline-flex; align-items: center; gap: 6px; height: 22px; padding: 0 8px; border: 0; border-radius: 999px;
  background: none; font: inherit; font-size: var(--superego-text-sm); color: var(--superego-muted); white-space: nowrap; cursor: default; }
.run-pill:not(.is-static):hover { background: var(--superego-hover); color: var(--superego-text); }
.run-pill.is-running, .run-pill.is-starting { color: var(--superego-text); }
.run-pill.is-failed { color: var(--superego-status-error-text, var(--superego-status-error)); }
.run-dot { flex: none; width: 7px; height: 7px; border-radius: 50%; background: var(--superego-faint); box-shadow: inset 0 0 0 1px var(--superego-border); }
:root { --run-green: light-dark(#1f9d45, #32d74b); --run-amber: light-dark(#c27c00, #ffc53d); --run-red: var(--superego-status-error, light-dark(#d70015, #ff6961)); }
.is-running .run-dot { background: var(--run-green); box-shadow: none; }
.is-starting .run-dot { background: var(--run-amber); box-shadow: none; animation: run-pulse 1.1s ease-in-out infinite; }
.is-failed .run-dot { background: var(--run-red); box-shadow: none; }
.run-mark.is-running { color: var(--run-green); }
.run-mark.is-starting { color: var(--run-amber); animation: run-pulse 1.1s ease-in-out infinite; }
.run-mark.is-failed { color: var(--run-red); }
@keyframes run-pulse { 0%, 100% { opacity: 1; } 50% { opacity: .3; } }
@media (prefers-reduced-motion: reduce) { .is-starting .run-dot, .run-mark.is-starting { animation: none; opacity: .6; } }

.run-logs { position: relative; display: flex; flex-direction: column; height: 100%; min-height: 0; }
.run-logs__bar { flex: none; display: flex; align-items: center; gap: 6px; padding: 6px 8px; border-bottom: 1px solid var(--superego-border); }
.run-logs__command { flex: 1 1 auto; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  font-family: var(--superego-mono); font-size: var(--superego-text-xs); color: var(--superego-muted); }
.run-button { display: inline-flex; align-items: center; gap: 4px; height: 24px; padding: 0 8px; border: 0; border-radius: var(--superego-radius);
  background: none; font: inherit; font-size: var(--superego-text-sm); color: var(--superego-text); cursor: default; }
.run-button:hover:not(:disabled) { background: var(--superego-hover); }
.run-button:disabled { color: var(--superego-faint); }
.run-logs__output { flex: 1 1 auto; min-height: 0; overflow: auto; padding: 8px 10px 24px; font-family: var(--superego-mono);
  font-size: var(--superego-text-mono, 12px); line-height: 1.45; color: var(--superego-text); user-select: text; }
.run-line { white-space: pre-wrap; overflow-wrap: anywhere; }
.run-logs__empty { display: flex; flex-direction: column; align-items: center; gap: 8px; text-align: center; }
.run-logs__empty p { margin: 0; max-width: 46ch; font-size: var(--superego-text-sm); }
.run-follow { position: absolute; right: 14px; bottom: 12px; display: inline-flex; align-items: center; gap: 4px; height: 24px; padding: 0 10px;
  border: 1px solid var(--superego-border); border-radius: 999px; background: var(--superego-raised, var(--superego-bg));
  box-shadow: var(--superego-shadow-float, none); font: inherit; font-size: var(--superego-text-xs); color: var(--superego-text); cursor: default; }
.run-logs {
  --run-c0: light-dark(#1d1d1f, #48484a); --run-c1: light-dark(#c9241b, #ff6961); --run-c2: light-dark(#1a7f37, #4cd964); --run-c3: light-dark(#946200, #ffd60a);
  --run-c4: light-dark(#0a5fd6, #64a8ff); --run-c5: light-dark(#a23ec4, #da8fff); --run-c6: light-dark(#0a7c8c, #5ac8fa); --run-c7: light-dark(#8e8e93, #d1d1d6);
  --run-c8: light-dark(#636366, #8e8e93); --run-c9: light-dark(#e0382d, #ff8f88); --run-c10: light-dark(#24963f, #7ee08f); --run-c11: light-dark(#b07800, #ffe066);
  --run-c12: light-dark(#2f7cf6, #8cc0ff); --run-c13: light-dark(#bf5af2, #e5b0ff); --run-c14: light-dark(#1695a8, #8ad8fb); --run-c15: light-dark(#c7c7cc, #ffffff);
}
`

export default defineUiExtension({
  ...about,
  setup(superego) {
    superego.view('run.pill', { title: 'Dev command', icon: TerminalIcon, context: 'thread', fits: ['header'], default: 'header', component: Pill })
    superego.view(LOGS_VIEW, { title: 'Run output', icon: TerminalIcon, context: 'thread', fits: ['pane'], default: 'pane', component: Logs })
    superego.slot('thread.badge', Mark)
    const style = document.createElement('style')
    style.textContent = STYLES
    document.head.append(style)
    return () => style.remove()
  },
})
