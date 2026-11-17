// The board: this thread's children at a glance, live. What each is doing, how long since it last made progress, a
// flag when the watchdog thinks it's stalled, its worktree, what its branch changed and whether that's merged, its last
// answer in a line, and an Archive button once it's idle. A child's report (what it said when it finished, errored or
// asked) sits under its row; once the child's archived, under Reports; either way until dismissed. Queued starts
// follow. Threads come from what the window knows; the rest from staff.ts.
import { useEffect, useMemo, useState, type ReactNode } from 'react'
import {
  ArchiveIcon, DiffStat, defineUiExtension, factsOf, has, IconButton, Markdown, PaneButton, PaneHeader, PaneMessage, PaneNote,
  ThreadRef, useDispatch, useMethod, useThreads, useValue, XIcon, type PaneProps,
} from 'superego/ui'
import { about, BOARD, PANE, type Changes, type Board, type Details, type Report } from './shared.ts'

const ago = (ms: number) => ms < 60_000 ? 'now' : ms < 3_600_000 ? `${Math.floor(ms / 60_000)}m` : `${Math.floor(ms / 3_600_000)}h ${Math.floor((ms % 3_600_000) / 60_000)}m`
const stateOf = (s: { state: string; kind?: string }) =>
  s.state === 'working' ? 'working' : s.state === 'blocked' ? (s.kind === 'question' ? 'waiting on question' : 'waiting on you') : s.state === 'error' ? 'errored' : 'idle'
const OUTCOME = { done: 'Finished', error: 'Errored', question: 'Asked' }
const merge = (merged: boolean | null | undefined) => merged === true ? ' · merged' : merged === false ? ' · not merged' : ''

/** What a branch changed: +/− and a count, opening to its files. */
function ChangesOf({ changes }: { changes: Changes }) {
  const count = changes.files.length + (changes.more ?? 0)
  return (
    <details className="staff-board__changes">
      <summary><DiffStat added={changes.added} removed={changes.removed} /> · {count} {count === 1 ? 'file' : 'files'}</summary>
      <ul>
        {changes.files.map((f) => <li key={f.path}><span className="staff-board__path">{f.path}</span><span className="staff-board__stat"><DiffStat added={f.added} removed={f.removed} /></span></li>)}
        {changes.more ? <li>and {changes.more} more</li> : null}
      </ul>
    </details>
  )
}

/** A report: how it ended and when, the first lines of what it said (all of it on a click), its changes, Dismiss. */
function ReportOf({ report, merged, now, dismiss, title }: { report: Report; merged?: boolean | null; now: number; dismiss(): void; title?: ReactNode }) {
  const [open, setOpen] = useState(false)
  return (
    <div className={`staff-board__report is-${report.outcome}`}>
      <div className="staff-board__line">
        {title}
        <span className="staff-board__outcome">{OUTCOME[report.outcome]} {now - report.at < 60_000 ? 'just now' : `${ago(now - report.at)} ago`}</span>
        <IconButton label="Dismiss" onClick={dismiss}><XIcon /></IconButton>
      </div>
      {report.answer && (
        // A click shows all of it, or the first lines again; one on a link follows the link.
        <div className={`staff-board__said${open ? ' is-open' : ''}`} title={open ? undefined : 'Show all'}
          onClick={(e) => { if (!(e.target as Element).closest('a')) setOpen(!open) }}>
          <Markdown text={report.answer} compact {...(open ? {} : { lines: 4 })} />
        </div>
      )}
      {report.changes?.files.length ? <div className="staff-board__meta"><ChangesOf changes={report.changes} /><span>{merge(merged ?? report.merged).slice(3)}</span></div> : null}
    </div>
  )
}

function BoardPane({ machine, thread }: PaneProps) {
  const dispatch = useDispatch()
  const all = useThreads(machine.id)
  const mine = useValue<Board>(machine, BOARD, { scope: thread.id }) ?? undefined
  const children = useMemo(() => (all ?? []).filter((t) => t.parent === thread.id && !t.archived).sort((a, b) => b.createdAt - a.createdAt), [all, thread.id])
  const reports = mine?.reports ?? []
  const reportOf = new Map(reports.map((r) => [r.id, r]))
  // Reports of children archived since: their own section.
  const gone = reports.filter((r) => !children.some((c) => c.id === r.id))
  const dismiss = (child?: string) => void dispatch('staff.dismiss', { id: thread.id, ...(child ? { child } : {}) }, { machine: machine.id })
  const [now, setNow] = useState(Date.now())
  useEffect(() => { const t = setInterval(() => setNow(Date.now()), 20_000); return () => clearInterval(t) }, [])
  // Again whenever a child moves on.
  const changed = [...children.map((c) => `${c.id}:${c.activeAt}:${c.status.state}`), ...reports.map((r) => `${r.id}:${r.at}`)].join(',')
  const { data } = useMethod<Details[]>(machine.id, 'staff.details', { id: thread.id },
    { enabled: machine.state === 'connected' && has(machine, 'ext:staff'), refresh: changed })
  const details = useMemo(() => Object.fromEntries((data ?? []).map((d) => [d.id, d])), [data])

  const running = children.filter((c) => c.status.state === 'working' || c.status.state === 'blocked').length
  if (!children.length && !mine?.queued.length && !reports.length) return <PaneMessage>No threads started yet.</PaneMessage>
  return (
    <div className="staff-board">
      <PaneHeader>
        <PaneNote>{running} running{mine?.queued.length ? ` · ${mine.queued.length} queued` : ''}{reports.length ? ` · ${reports.length} ${reports.length === 1 ? 'report' : 'reports'}` : ''}</PaneNote>
        {reports.length > 1 && <PaneButton onClick={() => dismiss()}>Dismiss all</PaneButton>}
      </PaneHeader>
      <ul>
        {children.map((child) => {
          const stalled = mine?.stalled[child.id]
          const d = details[child.id]
          const tree = factsOf<{ branch: string; removed?: boolean }>(child, 'worktrees')
          const report = reportOf.get(child.id)
          const changes = mine?.changes[child.id] ?? report?.changes
          const idle = child.status.state === 'idle' || child.status.state === 'done' || child.status.state === 'error'
          return (
            <li key={child.id} className={stalled ? 'is-stalled' : ''}>
              <div className="staff-board__line">
                <ThreadRef machine={machine.id} id={child.id} className="staff-board__title" />
                <span className="staff-board__state">{stateOf(child.status)}</span>
                <span className="staff-board__ago" title="Since its last step">{ago(now - child.activeAt)}</span>
                {idle && <IconButton label="Archive" onClick={() => void dispatch('thread.archive', { thread: child.id }, { machine: machine.id })}><ArchiveIcon /></IconButton>}
              </div>
              {stalled && <div className="staff-board__stall">Stalled {ago(now - stalled.since)}{stalled.call ? ` in ${stalled.call.replace(/`/g, '')}` : ''}</div>}
              <div className="staff-board__meta">
                {tree ? <span>{tree.branch.replace(/^superego\//, '')}{merge(d?.merged)}</span> : <span>in place</span>}
                {changes?.files.length ? <ChangesOf changes={changes} /> : null}
                {!report && d?.answer && child.status.state !== 'working' && <span className="staff-board__answer">{d.answer}</span>}
              </div>
              {report && <ReportOf report={{ ...report, changes: undefined }} now={now} dismiss={() => dismiss(child.id)} />}
            </li>
          )
        })}
        {gone.length > 0 && <li className="staff-board__heading">Reports</li>}
        {gone.map((report) => (
          <li key={`r${report.id}`}>
            <ReportOf
              report={report} merged={details[report.id]?.merged} now={now} dismiss={() => dismiss(report.id)}
              title={<ThreadRef machine={machine.id} id={report.id} className="staff-board__title">{report.title}</ThreadRef>}
            />
          </li>
        ))}
        {mine?.queued.map((q, i) => (
          <li key={`q${i}`} className="is-queued">
            <div className="staff-board__line">
              <span className="staff-board__dot" />
              <span className="staff-board__title">{q.title}</span>
              <span className="staff-board__state">queued</span>
              <span className="staff-board__ago">{ago(now - q.at)}</span>
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}

export default defineUiExtension({
  ...about,
  setup(superego) {
    superego.pane(PANE, { title: 'Board', component: BoardPane, menu: true })
    const style = document.createElement('style')
    style.textContent = `
      .staff-board { flex: 1; min-height: 0; overflow: auto; padding: var(--superego-space-2) var(--superego-space-3); line-height: 1.6; }
      .staff-board > ul { list-style: none; margin: 0; padding: 0; }
      .staff-board > ul > li { padding: var(--superego-space-2) 0; border-bottom: 1px solid var(--superego-border); }
      .staff-board > ul > li:last-child { border-bottom: 0; }
      .staff-board__line { display: flex; align-items: center; gap: 8px; min-height: 24px; }
      .staff-board__title { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
      .staff-board__state, .staff-board__ago { color: var(--superego-muted); font-size: 12px; white-space: nowrap; }
      .staff-board__ago { min-width: 3.5em; text-align: right; font-variant-numeric: tabular-nums; }
      .staff-board__meta { display: flex; flex-wrap: wrap; gap: 10px; margin-left: 18px; color: var(--superego-faint); font-size: 12px; min-width: 0; }
      .staff-board__meta span { white-space: nowrap; }
      .staff-board__answer { overflow: hidden; text-overflow: ellipsis; color: var(--superego-muted); }
      .staff-board__stall { margin-left: 18px; font-size: 12px; color: var(--superego-status-blocked-text); }
      .staff-board__dot { width: 8px; height: 8px; border-radius: 50%; border: 1px dashed var(--superego-faint); }
      .staff-board li.is-queued .staff-board__title { color: var(--superego-muted); }
      .staff-board li.staff-board__heading { padding: var(--superego-space-3) 0 var(--superego-space-1); color: var(--superego-muted); font-size: 11px; text-transform: uppercase; letter-spacing: .04em; }
      .staff-board__report { margin: 6px 0 0 18px; padding-left: 8px; border-left: 2px solid var(--superego-border); }
      .staff-board__report.is-error { border-left-color: var(--superego-status-error); }
      .staff-board__report.is-question { border-left-color: var(--superego-status-blocked); }
      li > .staff-board__report:first-child { margin: 0; padding-left: 0; border-left: 0; }
      .staff-board__outcome { flex: 1; color: var(--superego-muted); font-size: 12px; white-space: nowrap; }
      li > .staff-board__report:first-child .staff-board__outcome { flex: none; }
      .staff-board__said { margin-top: 2px; color: var(--superego-muted); cursor: pointer; }
      .staff-board__said.is-open { color: inherit; }
      .staff-board__said .md { line-height: 1.6; }
      .staff-board__report .staff-board__meta { margin-left: 0; margin-top: 4px; }
      .staff-board__changes[open] { flex-basis: 100%; }
      .staff-board__changes summary { cursor: pointer; white-space: nowrap; list-style: none; font-variant-numeric: tabular-nums; }
      .staff-board__changes summary::-webkit-details-marker { display: none; }
      .staff-board__changes ul { list-style: none; padding: 0; margin: 4px 0 2px; font-family: var(--superego-mono); font-size: 11px; }
      .staff-board__changes li { display: flex; gap: 8px; padding: 1px 0; border: 0; }
      .staff-board__path { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; }
      .staff-board__stat { font-variant-numeric: tabular-nums; }
    `
    document.head.append(style)
    return () => style.remove()
  },
})
