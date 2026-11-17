// The board: the user's overview of a lead's work, live, and where they answer what it needs of them. From the top: the
// programme's title, a line on where it stands and its waves as steps (board_plan); "Needs you": the decisions the lead
// put to the user (board_ask), the children's own questions (agent-ui's), stalls and failures; then the waves, each lane a
// child at work (its state, changes, time since its last step), a queued start, a planned one, or what landed (its
// report in a line, all of it on a fold). Without a plan, the children and what landed, ungrouped.
//
// It's driven from the keyboard (KEYS below): a cursor moves through it, a number answers the decision under it and
// sends after a moment, in which `z` takes it back. Threads come from what the window knows; the rest from staff.ts.
import { useEffect, useMemo, useRef, useState, type KeyboardEvent, type ReactNode } from 'react'
import {
  ArchiveIcon, DiffStat, defineUiExtension, factsOf, has, IconButton, Markdown, PaneHeader, PaneMessage, PaneNote,
  StatusGlyph, TextField, ThreadRef, useDispatch, useMethod, useSelection, useThreads, useValue, XIcon,
  type MachineEntry, type PaneProps, type ThreadInfo,
} from 'superego/ui'
import {
  about, ANSWER, BOARD, PANE, WAITING, type Board, type Changes, type Decision, type Details, type Option, type Report,
  type Waiting,
} from './shared.ts'

/** How long a picked answer waits before it's sent, for `z` to take it back. */
const UNDO_MS = 3_000

const ago = (ms: number) => ms < 60_000 ? 'now' : ms < 3_600_000 ? `${Math.floor(ms / 60_000)}m` : `${Math.floor(ms / 3_600_000)}h ${Math.floor((ms % 3_600_000) / 60_000)}m`
const same = (a: string, b: string) => a.trim().toLowerCase() === b.trim().toLowerCase()
const firstLine = (text: string) => text.split('\n').find((l) => l.trim())?.trim() ?? ''
const working = (t: ThreadInfo) => t.status.state === 'working' || t.status.state === 'blocked'
const settled = (t: ThreadInfo) => t.status.state === 'idle' || t.status.state === 'done' || t.status.state === 'error'

/** One row the cursor stops at, in the order drawn. */
type Item =
  | { key: string; kind: 'decision'; decision: Decision }
  | { key: string; kind: 'question'; child: ThreadInfo; waiting: Waiting }
  | { key: string; kind: 'stall' | 'failed'; child: ThreadInfo }
  | { key: string; kind: 'wave'; index: number }
  | { key: string; kind: 'child'; child: ThreadInfo; report?: Report }
  | { key: string; kind: 'landed'; report: Report }
  | { key: string; kind: 'queued' | 'planned'; title: string; at?: number }

/** A wave as drawn: its title, its lanes, whether it's all landed, and whether it shows them. */
type Wave = { index: number; title: string; lanes: Item[]; landed: boolean }

/** An answer picked and waiting to be sent: what it answers, in what words, when it goes. */
type Pending = { key: string; text: string; option?: number; until: number; send(): Promise<unknown> }

/** What a child waits on, as agent-ui publishes it, lifted to the board: one of these a live child. */
function Watch({ machine, child, onChange }: { machine: MachineEntry; child: string; onChange(child: string, waiting: Waiting | undefined): void }) {
  const waiting = useValue<Waiting[]>(machine, WAITING, { scope: child })
  const first = waiting?.[0]
  useEffect(() => { onChange(child, first) }, [child, first?.id])
  useEffect(() => () => onChange(child, undefined), [child])
  return null
}

/** Numbered options; the one picked, marked while it waits to be sent. */
function Options({ options, picked, pick }: { options: Option[]; picked?: number; pick(i: number): void }) {
  return (
    <div className="staff-board__options">
      {options.map((o, i) => (
        <button key={i} type="button" className={picked === i ? 'is-picked' : ''} onClick={(e) => { e.stopPropagation(); pick(i) }}>
          <kbd>{i + 1}</kbd><span className="staff-board__label">{o.label}</span>{o.description && <span className="staff-board__desc">{o.description}</span>}
        </button>
      ))}
    </div>
  )
}

/** What a branch changed: +/−, and how many files. */
const Changed = ({ changes }: { changes: Changes }) => {
  const count = changes.files.length + (changes.more ?? 0)
  return <span className="staff-board__stat" title={changes.files.map((f) => `${f.path} +${f.added} −${f.removed}`).join('\n')}><DiffStat added={changes.added} removed={changes.removed} /> · {count} {count === 1 ? 'file' : 'files'}</span>
}

const KEYS: [string, string][] = [
  ['j k ↓ ↑', 'Move'],
  ['⏎', 'Open the thread beside (⌘⏎ in its place)'],
  ['1–9', 'Answer the decision under the cursor'],
  ['z', 'Take back an answer before it’s sent'],
  ['r', 'Answer in words'],
  ['n N', 'Next and previous open question'],
  ['space', 'Fold a wave, or open a report'],
  ['x', 'Dismiss an answered decision or a report'],
  ['a', 'Archive the child, once it’s done'],
  ['? esc', 'These keys'],
]

function BoardPane({ machine, thread }: PaneProps) {
  const dispatch = useDispatch()
  const { select } = useSelection()
  const all = useThreads(machine.id)
  const mine = useValue<Board>(machine, BOARD, { scope: thread.id }) ?? undefined
  const children = useMemo(() => (all ?? []).filter((t) => t.parent === thread.id && !t.archived).sort((a, b) => a.createdAt - b.createdAt), [all, thread.id])
  const reports = mine?.reports ?? []
  const decisions = mine?.decisions ?? []
  const plan = mine?.plan
  const [now, setNow] = useState(Date.now())
  useEffect(() => { const t = setInterval(() => setNow(Date.now()), 20_000); return () => clearInterval(t) }, [])
  const changed = [...children.map((c) => `${c.id}:${c.activeAt}:${c.status.state}`), ...reports.map((r) => `${r.id}:${r.at}`)].join(',')
  const { data } = useMethod<Details[]>(machine.id, 'staff.details', { id: thread.id },
    { enabled: machine.state === 'connected' && has(machine, 'ext:staff'), refresh: changed })
  const details = useMemo(() => Object.fromEntries((data ?? []).map((d) => [d.id, d])), [data])

  // What each child waits on, as its Watch says.
  const [waits, setWaits] = useState<Record<string, Waiting>>({})
  const onWait = useMemo(() => (child: string, waiting: Waiting | undefined) => setWaits((w) => {
    if (w[child]?.id === waiting?.id) return w
    const next = { ...w }
    if (waiting) next[child] = waiting
    else delete next[child]
    return next
  }), [])

  const [cursor, setCursor] = useState<string>()
  const [folded, setFolded] = useState<Record<string, boolean>>({})
  const [opened, setOpened] = useState<Record<string, boolean>>({})
  const [replying, setReplying] = useState<string>()
  const [failed, setFailed] = useState<Record<string, string>>({})
  const [help, setHelp] = useState(false)
  const [pending, setPending] = useState<Pending>()
  const root = useRef<HTMLDivElement>(null)

  // A picked answer goes when its moment is up, or at once if the board goes away first.
  const pendingRef = useRef(pending)
  pendingRef.current = pending
  const flush = (p: Pending | undefined) => {
    if (!p) return
    pendingRef.current = undefined
    setPending((q) => q === p ? undefined : q)
    p.send().then(() => setFailed(({ [p.key]: _, ...rest }) => rest), (error: Error) => setFailed((f) => ({ ...f, [p.key]: error.message })))
  }
  const [, tick] = useState(0)
  useEffect(() => {
    if (!pending) return
    const t = setInterval(() => { if (Date.now() >= pending.until) flush(pending); else tick((n) => n + 1) }, 200)
    return () => clearInterval(t)
  }, [pending])
  useEffect(() => () => flush(pendingRef.current), [])

  // ── What's drawn, as items in order ─────────────────────────────────────────────────────────────────────────────────
  const reportOf = new Map(reports.map((r) => [r.id, r]))
  const laneOf = (child: ThreadInfo): Item => ({ key: `child:${child.id}`, kind: 'child', child, report: reportOf.get(child.id) })
  const isLanded = (item: Item) => item.kind === 'landed' || (item.kind === 'child' && settled(item.child) && item.report?.outcome === 'done')
  const gone = reports.filter((r) => !children.some((c) => c.id === r.id))
  const queued = mine?.queued ?? []

  const needs: Item[] = [
    ...decisions.map((decision): Item => ({ key: `decision:${decision.id}`, kind: 'decision', decision })),
    ...children.flatMap((child): Item[] => {
      const waiting = waits[child.id]
      if (waiting) return [{ key: `question:${child.id}`, kind: 'question', child, waiting }]
      if (mine?.stalled[child.id]) return [{ key: `stall:${child.id}`, kind: 'stall', child }]
      if (child.status.state === 'error') return [{ key: `failed:${child.id}`, kind: 'failed', child }]
      return []
    }),
  ]
  const waves: Wave[] = []
  if (plan?.waves.length) {
    const placed = new Set<string>()
    plan.waves.forEach((w, index) => {
      const lanes = w.lanes.map((lane): Item => {
        const child = children.find((c) => !placed.has(c.id) && (c.id === lane || same(c.title, lane)))
        if (child) { placed.add(child.id); return laneOf(child) }
        const report = gone.find((r) => !placed.has(r.id) && (r.id === lane || same(r.title, lane)))
        if (report) { placed.add(report.id); return { key: `landed:${report.id}`, kind: 'landed', report } }
        const start = queued.find((q) => same(q.title, lane))
        if (start) { placed.add(`queued:${start.title}`); return { key: `queued:${start.title}`, kind: 'queued', title: start.title, at: start.at } }
        return { key: `planned:${index}:${lane}`, kind: 'planned', title: lane }
      })
      waves.push({ index, title: w.title, lanes, landed: lanes.length > 0 && lanes.every(isLanded) })
    })
    // What no wave names joins the one under way (the first not all landed), or the last.
    const current = waves.find((w) => !w.landed) ?? waves.at(-1)!
    current.lanes.push(
      ...children.filter((c) => !placed.has(c.id)).map(laneOf),
      ...queued.filter((q) => !placed.has(`queued:${q.title}`)).map((q): Item => ({ key: `queued:${q.title}`, kind: 'queued', title: q.title, at: q.at })),
    )
    const rest = gone.filter((r) => !placed.has(r.id))
    if (rest.length) waves.push({ index: -1, title: 'Landed', lanes: rest.map((report): Item => ({ key: `landed:${report.id}`, kind: 'landed', report })), landed: true })
  } else {
    const lanes = [
      ...children.map(laneOf),
      ...queued.map((q): Item => ({ key: `queued:${q.title}`, kind: 'queued', title: q.title, at: q.at })),
    ]
    if (lanes.length) waves.push({ index: -2, title: '', lanes, landed: false })
    if (gone.length) waves.push({ index: -1, title: 'Landed', lanes: gone.map((report): Item => ({ key: `landed:${report.id}`, kind: 'landed', report })), landed: true })
  }
  // A wave all landed folds to a line; what landed outside the waves shows, until folded.
  const shows = (w: Wave) => w.index === -2 || !(folded[`wave:${w.index}`] ?? (w.landed && w.index >= 0))
  const items: Item[] = [...needs, ...waves.flatMap((w) => [
    ...(w.index === -2 ? [] : [{ key: `wave:${w.index}`, kind: 'wave', index: w.index } as Item]),
    ...(shows(w) ? w.lanes : []),
  ])]
  const at = items.find((i) => i.key === cursor) ?? items[0]

  // The cursor stays in view, within the board.
  useEffect(() => {
    const box = root.current?.querySelector<HTMLElement>('.staff-board__body')
    const el = box?.querySelector<HTMLElement>(`[data-key="${CSS.escape(at?.key ?? '')}"]`)
    if (!box || !el) return
    const top = el.getBoundingClientRect().top - box.getBoundingClientRect().top + box.scrollTop
    if (top < box.scrollTop) box.scrollTop = top - 8
    else if (top + el.offsetHeight > box.scrollTop + box.clientHeight) box.scrollTop = top + el.offsetHeight - box.clientHeight + 8
  }, [at?.key])

  // ── Doing things ────────────────────────────────────────────────────────────────────────────────────────────────────
  const on = { machine: machine.id }
  const open = (id: string, beside = true) => beside
    ? void dispatch('pane.open', { thread: thread.id, kind: 'thread', params: { thread: id } }, on)
    : select({ machine: machine.id, thread: id })
  const threadOf = (item: Item | undefined): string | undefined => {
    if (!item) return undefined
    if (item.kind === 'decision') {
      const about = item.decision.about[0]
      return about && (children.find((c) => c.id === about || same(c.title, about))?.id ?? reports.find((r) => r.id === about || same(r.title, about))?.id)
    }
    if ('child' in item) return item.child.id
    if (item.kind === 'landed') return item.report.id
    return undefined
  }
  /** Answer what the item asks, in these words, once the moment to take it back is up. */
  const answer = (item: Item, text: string, option?: number) => {
    if (item.kind === 'decision') {
      if (item.decision.answer) return
      const send = () => dispatch('staff.decide', { id: thread.id, decision: item.decision.id, text }, on)
      if (pending && pending.key !== item.key) flush(pending)
      setPending({ key: item.key, text, option, until: Date.now() + UNDO_MS, send })
    } else if (item.kind === 'question') {
      const { child, waiting } = item
      const send = async () => {
        await dispatch(ANSWER, { id: waiting.id, text }, on)
        await dispatch('staff.relay', { id: thread.id, child: child.id, question: waiting.question ?? waiting.title ?? '', text }, on)
      }
      if (pending && pending.key !== item.key) flush(pending)
      setPending({ key: item.key, text, option, until: Date.now() + UNDO_MS, send })
    }
    setCursor(item.key)
  }
  const optionsOf = (item: Item | undefined): Option[] =>
    item?.kind === 'decision' && !item.decision.answer ? item.decision.options : item?.kind === 'question' ? item.waiting.options ?? [] : []
  const dismiss = (item: Item | undefined) => {
    if (item?.kind === 'decision' && item.decision.answer) void dispatch('staff.dismiss', { id: thread.id, decision: item.decision.id }, on)
    else if (item?.kind === 'landed' || (item?.kind === 'child' && item.report && settled(item.child))) void dispatch('staff.dismiss', { id: thread.id, child: item.kind === 'landed' ? item.report.id : item.child.id }, on)
  }
  const archive = (item: Item | undefined) => {
    if (item && 'child' in item && settled(item.child)) void dispatch('thread.archive', { thread: item.child.id }, on)
  }
  const toggle = (item: Item | undefined) => {
    if (item?.kind === 'wave') { const w = waves.find((x) => x.index === item.index)!; setFolded((f) => ({ ...f, [item.key]: shows(w) })) }
    else if (item) setOpened((o) => ({ ...o, [item.key]: !o[item.key] }))
  }
  const asks = (item: Item) => (item.kind === 'decision' && !item.decision.answer) || item.kind === 'question'

  const onKeyDown = (e: KeyboardEvent<HTMLDivElement>) => {
    if ((e.target as HTMLElement).closest('input, textarea, [contenteditable]')) return
    const k = e.key
    if (k === 'Enter' && !e.altKey && !e.ctrlKey) {
      const id = threadOf(at)
      if (at?.kind === 'wave') toggle(at)
      else if (id) open(id, !e.metaKey)
    } else if (e.metaKey || e.ctrlKey || e.altKey) return
    else if (help && (k === 'Escape' || k === '?')) setHelp(false)
    else if (k === 'j' || k === 'ArrowDown' || k === 'k' || k === 'ArrowUp') {
      const i = items.indexOf(at!)
      const next = items[Math.max(0, Math.min(items.length - 1, i + (k === 'j' || k === 'ArrowDown' ? 1 : -1)))]
      if (next) setCursor(next.key)
    } else if (/^[1-9]$/.test(k)) {
      const option = optionsOf(at)[Number(k) - 1]
      if (option && at) answer(at, option.label, Number(k) - 1)
    } else if (k === 'z') { if (pending) setPending(undefined) }
    else if (k === 'r') { if (at && asks(at)) setReplying(at.key) }
    else if (k === 'n' || k === 'N') {
      const asking = items.filter(asks)
      const i = items.indexOf(at!)
      const next = k === 'n' ? asking.find((o) => items.indexOf(o) > i) ?? asking[0] : asking.findLast((o) => items.indexOf(o) < i) ?? asking.at(-1)
      if (next) setCursor(next.key)
    } else if (k === ' ') toggle(at)
    else if (k === 'x') dismiss(at)
    else if (k === 'a') archive(at)
    else if (k === '?') setHelp(true)
    else if (k === 'Escape') root.current?.blur()
    else return
    e.preventDefault()
  }

  // ── Drawing ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  const ref = (about: string) => {
    const t = children.find((c) => c.id === about || same(c.title, about)) ?? reports.find((r) => r.id === about || same(r.title, about))
    return t ? <ThreadRef key={about} machine={machine.id} id={t.id} /> : <span key={about}>{about}</span>
  }
  const row = (item: Item, className: string, inner: ReactNode) => (
    <div key={item.key} data-key={item.key} className={`staff-board__item ${className}${item === at ? ' is-cursor' : ''}`} onClick={() => setCursor(item.key)}>
      {inner}
    </div>
  )
  const reply = (item: Item) => replying === item.key && (
    <TextField
      autoFocus className="staff-board__reply" placeholder="Answer in words"
      onKeyDown={(e) => {
        const value = e.currentTarget.value.trim()
        if (e.key === 'Enter' && value) { answer(item, value); setReplying(undefined); root.current?.focus() }
        if (e.key === 'Escape') { setReplying(undefined); root.current?.focus() }
        e.stopPropagation()
      }}
    />
  )
  const sending = (item: Item) => {
    if (pending?.key === item.key) {
      return <div className="staff-board__sending">Sending “{pending.text}” in {Math.max(1, Math.ceil((pending.until - Date.now()) / 1000))}… <kbd>z</kbd> takes it back</div>
    }
    return failed[item.key] ? <div className="staff-board__failed">{failed[item.key]}</div> : null
  }
  const ask = (item: Item) => {
    if (item.kind === 'decision') {
      const { decision: d } = item
      if (d.answer) {
        return row(item, 'staff-board__ask is-answered', <>
          <div className="staff-board__line"><span className="staff-board__glyph is-answered" /><span className="staff-board__q">{d.question}</span>
            <IconButton label="Dismiss" onClick={(e) => { e.stopPropagation(); dismiss(item) }}><XIcon /></IconButton></div>
          <div className="staff-board__about">→ {d.answer.text}{d.answer.by === 'lead' ? ' (closed by the lead)' : ''} · {ago(now - d.answer.at)}</div>
        </>)
      }
      return row(item, 'staff-board__ask', <>
        <div className="staff-board__line"><span className="staff-board__glyph is-asking" /><span className="staff-board__q">{d.question}</span></div>
        <div className="staff-board__about">{d.about.length ? <>the lead, about {d.about.map((a, i) => <span key={a}>{i ? ', ' : ''}{ref(a)}</span>)}</> : 'the lead'} · {ago(now - d.at)}</div>
        <Options options={d.options} picked={pending?.key === item.key ? pending.option : undefined} pick={(i) => answer(item, d.options[i]!.label, i)} />
        {sending(item)}{reply(item)}
      </>)
    }
    if (item.kind === 'question') {
      const { child, waiting: w } = item
      return row(item, 'staff-board__ask', <>
        <div className="staff-board__line"><span className="staff-board__glyph is-asking" /><span className="staff-board__q">{firstLine(w.question ?? w.title ?? 'Waiting for your answer')}</span></div>
        <div className="staff-board__about"><ThreadRef machine={machine.id} id={child.id} /> asks · {ago(now - w.at)}</div>
        {w.question
          ? <><Options options={w.options ?? []} picked={pending?.key === item.key ? pending.option : undefined} pick={(i) => answer(item, w.options![i]!.label, i)} />{sending(item)}{reply(item)}</>
          : <div className="staff-board__about">Answer it in its thread: <kbd>⏎</kbd></div>}
      </>)
    }
    if (item.kind === 'stall') {
      const stall = mine!.stalled[item.child.id]!
      return row(item, 'staff-board__ask', <>
        <div className="staff-board__line"><span className="staff-board__glyph is-stalled" /><span className="staff-board__q"><ThreadRef machine={machine.id} id={item.child.id} /> has made no progress for {ago(now - stall.since)}</span></div>
        {stall.call && <div className="staff-board__about">in {stall.call.replace(/`/g, '')}</div>}
      </>)
    }
    if (item.kind === 'failed') {
      return row(item, 'staff-board__ask', <>
        <div className="staff-board__line"><StatusGlyph status={item.child.status} /><span className="staff-board__q"><ThreadRef machine={machine.id} id={item.child.id} /> failed</span></div>
        {item.child.status.msg && <div className="staff-board__about">{firstLine(item.child.status.msg)}</div>}
      </>)
    }
    return null
  }
  const said = (item: Item, report: Report) => report.answer && (
    <div className="staff-board__sub staff-board__said"><Markdown text={report.answer} compact {...(opened[item.key] ? {} : { lines: 1 })} /></div>
  )
  const lane = (item: Item) => {
    if (item.kind === 'child') {
      const { child, report } = item
      const d = details[child.id]
      const tree = factsOf<{ branch: string }>(child, 'worktrees')
      const changes = mine?.changes[child.id] ?? report?.changes
      const stall = mine?.stalled[child.id]
      const landed = isLanded(item)
      const merged = d?.merged ?? report?.merged
      const needsYou = needs.some((n) => n.kind === 'question' && n.child.id === child.id) ||
        decisions.some((x) => !x.answer && x.about.some((a) => a === child.id || same(a, child.title)))
      const sub = stall ? <div className="staff-board__sub is-stalled">Stalled {ago(now - stall.since)}{stall.call ? ` in ${stall.call.replace(/`/g, '')}` : ''}</div>
        : landed && report ? said(item, report)
        : child.status.state !== 'working' && d?.answer ? <div className="staff-board__sub">{d.answer}</div>
        : tree ? <div className="staff-board__sub">{tree.branch.replace(/^superego\//, '')}</div> : null
      return row(item, 'staff-board__lane', <>
        <div className="staff-board__line">
          {landed ? <span className="staff-board__glyph is-landed" /> : <StatusGlyph status={child.status} />}
          <ThreadRef machine={machine.id} id={child.id} className="staff-board__title" />
          {needsYou && <span className="staff-board__need">needs you</span>}
          {changes?.files.length ? <Changed changes={changes} /> : null}
          {landed && merged !== null && merged !== undefined && <span className="staff-board__meta">{merged ? 'merged' : 'not merged'}</span>}
          <span className="staff-board__ago" title="Since its last step">{ago(now - child.activeAt)}</span>
          {settled(child) && <IconButton label="Archive" onClick={(e) => { e.stopPropagation(); archive(item) }}><ArchiveIcon /></IconButton>}
        </div>
        {sub}
      </>)
    }
    if (item.kind === 'landed') {
      const { report } = item
      const merged = details[report.id]?.merged ?? report.merged
      return row(item, 'staff-board__lane', <>
        <div className="staff-board__line">
          <span className={`staff-board__glyph ${report.outcome === 'done' ? 'is-landed' : 'is-failed'}`} />
          <ThreadRef machine={machine.id} id={report.id} className="staff-board__title">{report.title}</ThreadRef>
          {report.changes?.files.length ? <Changed changes={report.changes} /> : null}
          {merged !== null && merged !== undefined && <span className="staff-board__meta">{merged ? 'merged' : 'not merged'}</span>}
          <span className="staff-board__ago">{ago(now - report.at)}</span>
          <IconButton label="Dismiss" onClick={(e) => { e.stopPropagation(); dismiss(item) }}><XIcon /></IconButton>
        </div>
        {said(item, report)}
      </>)
    }
    if (item.kind === 'queued' || item.kind === 'planned') {
      return row(item, 'staff-board__lane is-quiet', <>
        <div className="staff-board__line">
          <span className={`staff-board__glyph is-${item.kind}`} />
          <span className="staff-board__title">{item.title}</span>
          <span className="staff-board__meta">{item.kind}</span>
          {item.at && <span className="staff-board__ago">{ago(now - item.at)}</span>}
        </div>
      </>)
    }
    return null
  }
  const wave = (w: Wave) => {
    const header = items.find((i) => i.key === `wave:${w.index}`)
    const landed = w.lanes.filter(isLanded)
    const sum = (k: 'added' | 'removed') => landed.reduce((n, i) => n + ((i.kind === 'landed' ? i.report.changes : i.kind === 'child' ? i.report?.changes : undefined)?.[k] ?? 0), 0)
    const live = w.lanes.filter((i) => i.kind === 'child' && working(i.child)).length
    const next = w.lanes.filter((i) => i.kind === 'queued' || i.kind === 'planned').length
    const meta = w.landed ? <>{landed.length} landed{sum('added') || sum('removed') ? <> · <DiffStat added={sum('added')} removed={sum('removed')} /></> : null}</>
      : [live && `${live} running`, landed.length && `${landed.length} landed`, next && `${next} next`].filter(Boolean).join(' · ')
    return (
      <section key={w.index} className="staff-board__wave">
        {header && row(header, 'staff-board__wavehead', <>
          <span className="staff-board__chev">{shows(w) ? '▾' : '▸'}</span>
          <span className="staff-board__wavetitle">{w.index >= 0 ? `Wave ${w.index + 1} · ${w.title}` : w.title}</span>
          <span className="staff-board__meta">{meta}</span>
        </>)}
        {shows(w) && w.lanes.map(lane)}
      </section>
    )
  }

  const running = children.filter(working).length
  const needing = needs.filter((n) => n.kind !== 'decision' || !n.decision.answer).length
  const watches = children.map((c) => <Watch key={c.id} machine={machine} child={c.id} onChange={onWait} />)
  if (!items.length && !plan) return <>{watches}<PaneMessage>No threads started yet.</PaneMessage></>
  return (
    <div className="staff-board" ref={root} tabIndex={0} onKeyDown={onKeyDown}>
      {watches}
      <PaneHeader>
        <PaneNote>{needing ? `${needing} need${needing === 1 ? 's' : ''} you · ` : ''}{running} running{queued.length ? ` · ${queued.length} queued` : ''}</PaneNote>
      </PaneHeader>
      <div className="staff-board__body">
        {plan && (plan.title || plan.summary || plan.waves.length > 1) && (
          <div className="staff-board__plan">
            {plan.title && <div className="staff-board__programme">{plan.title}</div>}
            {plan.summary && <div className="staff-board__summary">{plan.summary}</div>}
            {plan.waves.length > 1 && (
              <div className="staff-board__steps">
                {waves.filter((w) => w.index >= 0).map((w, i) => (
                  <span key={w.index} className="staff-board__step">
                    {i > 0 && <span className={`staff-board__bar${w.landed || w.lanes.some((l) => isLanded(l) || (l.kind === 'child' && working(l.child))) ? ' is-on' : ''}`} />}
                    <span className={`staff-board__glyph ${w.landed ? 'is-landed' : w.lanes.some((l) => l.kind === 'child') ? 'is-working' : 'is-planned'}`} />
                    <span title={w.title}>{w.index + 1}</span>
                  </span>
                ))}
              </div>
            )}
          </div>
        )}
        {needs.length > 0 && (
          <section className="staff-board__needs">
            <div className="staff-board__heading">Needs you{needing ? <span className="staff-board__count"> {needing}</span> : null}</div>
            {needs.map(ask)}
          </section>
        )}
        {waves.map(wave)}
      </div>
      {help && (
        <div className="staff-board__help" onClick={() => setHelp(false)}>
          <table><tbody>{KEYS.map(([keys, what]) => <tr key={keys}><td>{keys.split(' ').map((k) => <kbd key={k}>{k}</kbd>)}</td><td>{what}</td></tr>)}</tbody></table>
        </div>
      )}
    </div>
  )
}

export default defineUiExtension({
  ...about,
  setup(superego) {
    superego.pane(PANE, { title: 'Board', component: BoardPane, menu: true })
    const style = document.createElement('style')
    style.textContent = `
      .staff-board { flex: 1; min-height: 0; display: flex; flex-direction: column; position: relative; outline: none; }
      .staff-board__body { flex: 1; min-height: 0; overflow: auto; padding: var(--superego-space-2) var(--superego-space-3) var(--superego-space-6); line-height: 1.45; }
      .staff-board kbd { font: 11px var(--superego-mono); min-width: 18px; height: 18px; display: inline-grid; place-items: center; padding: 0 4px; border-radius: 4px; background: var(--superego-code-chip); box-shadow: inset 0 -1px 0 var(--superego-border); color: var(--superego-muted); }
      .staff-board__item { border-radius: var(--superego-radius); padding: 5px var(--superego-space-3); margin: 0 calc(-1 * var(--superego-space-3)); }
      .staff-board__item.is-cursor { background: var(--superego-selected); }
      .staff-board:focus-within .staff-board__item.is-cursor { box-shadow: inset 2px 0 0 var(--superego-accent); }
      .staff-board__line { display: flex; align-items: center; gap: 8px; min-height: 22px; min-width: 0; }
      .staff-board__title { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
      .staff-board__meta, .staff-board__ago, .staff-board__stat { color: var(--superego-faint); font-size: var(--superego-text-sm); white-space: nowrap; font-variant-numeric: tabular-nums; }
      .staff-board__ago { min-width: 3em; text-align: right; }
      .staff-board__sub { margin-left: 22px; color: var(--superego-muted); font-size: var(--superego-text-sm); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
      .staff-board__sub.is-stalled { color: var(--superego-status-blocked-text); }
      .staff-board__said { white-space: normal; }
      .staff-board__said .md { line-height: 1.5; }
      .staff-board__glyph { flex: none; display: inline-flex; width: 1em; height: 1em; align-items: center; justify-content: center; color: var(--superego-status-idle); }
      .staff-board__glyph::before { content: ''; box-sizing: border-box; width: var(--superego-status-dot); height: var(--superego-status-dot); border-radius: 50%; background: currentColor; }
      .staff-board__glyph.is-asking { color: var(--superego-status-blocked); }
      .staff-board__glyph.is-stalled { color: var(--superego-status-blocked); }
      .staff-board__glyph.is-stalled::before, .staff-board__glyph.is-working::before, .staff-board__glyph.is-planned::before { background: none; border: 1.5px solid currentColor; }
      .staff-board__glyph.is-working { color: var(--superego-accent); }
      .staff-board__glyph.is-queued::before { background: none; border: 1.5px dashed var(--superego-faint); }
      .staff-board__glyph.is-failed { color: var(--superego-status-error); }
      .staff-board__glyph.is-landed, .staff-board__glyph.is-answered { color: var(--superego-accent); }
      .staff-board__glyph.is-answered { color: var(--superego-faint); }
      .staff-board__glyph.is-landed::before, .staff-board__glyph.is-answered::before { content: '✓'; width: auto; height: auto; background: none; font-size: 11px; font-weight: 700; line-height: 1; }
      .staff-board__heading { display: flex; gap: 4px; margin: var(--superego-space-3) 0 var(--superego-space-1); font-size: var(--superego-text-sm); font-weight: 600; color: var(--superego-muted); }
      .staff-board__count { color: var(--superego-status-blocked-text); }
      .staff-board__ask { padding-top: 8px; padding-bottom: 8px; }
      .staff-board__ask + .staff-board__ask { border-top: 1px solid var(--superego-line); }
      .staff-board__ask.is-cursor, .staff-board__ask.is-cursor + .staff-board__ask { border-top-color: transparent; }
      .staff-board__ask.is-answered { opacity: .75; }
      .staff-board__q { flex: 1; min-width: 0; }
      .staff-board__about { margin-left: 22px; color: var(--superego-muted); font-size: var(--superego-text-sm); }
      .staff-board__options { display: flex; flex-direction: column; gap: 1px; margin: 6px 0 0 14px; }
      .staff-board__options button { all: unset; display: flex; align-items: baseline; gap: 8px; padding: 3px 8px; border-radius: var(--superego-radius); cursor: default; }
      .staff-board__options button:hover { background: var(--superego-hover); }
      .staff-board__options button.is-picked { background: color-mix(in oklab, var(--superego-accent) 14%, transparent); }
      .staff-board__options button.is-picked kbd { background: var(--superego-accent); color: var(--superego-accent-text); box-shadow: none; }
      .staff-board__label { font-weight: 500; }
      .staff-board__desc { color: var(--superego-muted); font-size: var(--superego-text-sm); }
      .staff-board__sending { margin: 6px 0 0 22px; font-size: var(--superego-text-sm); color: var(--superego-accent); display: flex; gap: 6px; align-items: center; }
      .staff-board__failed { margin: 6px 0 0 22px; font-size: var(--superego-text-sm); color: var(--superego-status-error-text); }
      .staff-board__reply { margin: 6px 0 0 22px; width: calc(100% - 22px); }
      .staff-board__plan { padding: var(--superego-space-2) 0; }
      .staff-board__programme { font-weight: 600; font-size: calc(15px * var(--superego-text-scale)); }
      .staff-board__summary { color: var(--superego-muted); margin-top: 2px; }
      .staff-board__steps { display: flex; align-items: center; margin-top: var(--superego-space-3); font-size: var(--superego-text-sm); color: var(--superego-muted); }
      .staff-board__step { display: contents; }
      .staff-board__step > span:last-child { margin: 0 2px 0 4px; font-weight: 600; color: var(--superego-text); }
      .staff-board__bar { flex: 1; height: 2px; margin: 0 6px; border-radius: 2px; background: var(--superego-line); }
      .staff-board__bar.is-on { background: var(--superego-accent); }
      .staff-board__wave { margin-top: var(--superego-space-2); border-top: 1px solid var(--superego-line); padding-top: var(--superego-space-1); }
      .staff-board__needs + .staff-board__wave, .staff-board__plan + .staff-board__wave { margin-top: var(--superego-space-3); }
      .staff-board__body > .staff-board__wave:first-child { border-top: 0; margin-top: 0; }
      .staff-board__wavehead { display: flex; align-items: center; gap: 8px; }
      .staff-board__wavetitle { flex: 1; font-weight: 600; }
      .staff-board__chev { width: 12px; color: var(--superego-muted); font-size: 12px; }
      .staff-board__lane.is-quiet .staff-board__title { color: var(--superego-muted); }
      .staff-board__need { background: color-mix(in oklab, var(--superego-status-blocked) 18%, transparent); color: var(--superego-status-blocked-text); border-radius: 999px; padding: 0 8px; font-size: var(--superego-text-sm); white-space: nowrap; }
      .staff-board__help { position: absolute; inset: 0; z-index: 1; background: color-mix(in oklab, var(--superego-bg) 92%, transparent); backdrop-filter: blur(6px); padding: var(--superego-space-6); }
      .staff-board__help td { padding: 4px 18px 4px 0; vertical-align: top; }
      .staff-board__help td:first-child { white-space: nowrap; display: flex; gap: 4px; }
    `
    document.head.append(style)
    return () => style.remove()
  },
})
