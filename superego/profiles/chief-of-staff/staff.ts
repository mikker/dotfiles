// The chief of staff's machinery, for threads with this profile (its "leads"): a watchdog over their children, check-ins
// they schedule for themselves, a cap on how many children run at once (thread_start beyond it queues the start), and
// what the board pane shows: each child's changes, and its reports, kept until the user dismisses them. One timer, owned
// by the extension and gone with it; what must survive a restart (check-ins, queued starts, reports) is kept in each
// lead's state.
import { execFile } from 'node:child_process'
import {
  defineAction, defineDaemonExtension, defineExtension, defineTool, num, obj, opt, str, wrapTool, type ThreadInfo,
} from 'superego'
import { about, BOARD, EMPTY_BOARD, type Board, type Changes, type Details, type Report } from './shared.ts'

const PROFILE = 'chief-of-staff'
const MINUTE = 60_000

type Start = { prompt: string; title?: string; cwd?: string; profile?: string; worktree?: boolean }
type CheckIn = { at: number; note: string }
type Queued = { args: Start; at: number }
/** `reported`: by child, the activity (activeAt) its last report was of, so each is recorded once, dismissed or not. */
type State = { checkIns?: CheckIn[]; queue?: Queued[]; reports?: Report[]; reported?: Record<string, number> }
/** A thread's worktree, as the worktrees extension tells it (`facts.worktrees`). */
type Worktree = { path: string; branch: string; removed?: boolean }

export type StaffOptions = {
  /** How often it looks: the watchdog, due check-ins and the queue. */
  tickMs?: number
  /** A working child with no new transcript entry for this long is stalled. */
  stallMs?: number
  /** Children running at once, before thread_start queues. */
  cap?: number
}

const text = (value: string) => ({ output: [{ type: 'text' as const, text: value }] })
const linkTo = (t: { id: string; title: string }) => `[${t.title.replace(/[[\]]/g, '')}](thread:${t.id})`
const minutes = (ms: number) => `${Math.max(1, Math.round(ms / MINUTE))} min`
const worktreeOf = (t: ThreadInfo) => t.facts?.worktrees as Worktree | undefined

/** Whether it takes a slot: working, waiting on the user, or just started and not yet going. */
const running = (t: ThreadInfo, now: number) => !t.archived &&
  (t.status.state === 'working' || t.status.state === 'blocked' || (t.status.state === 'idle' && now - t.createdAt < MINUTE && t.activeAt <= t.createdAt))

const git = (cwd: string, ...args: string[]) => new Promise<string | undefined>((resolve) => {
  execFile('git', ['-C', cwd, ...args], { timeout: 5_000 }, (error, out) => resolve(error ? undefined : out.trim()))
})

/** A worktree child's branch, and where to run git on it (the main checkout, once the worktree is gone). */
function branchOf(t: ThreadInfo) {
  const tree = worktreeOf(t)
  return tree && { branch: tree.branch, at: tree.removed ? t.project.root : tree.path }
}

/** Whether a worktree's branch is in the local main: it moved since it was made (its reflog) and main has all of it. */
async function mergedOf(t: ThreadInfo): Promise<boolean | undefined> {
  const tree = branchOf(t)
  if (!tree) return undefined
  const { at } = tree
  const main = (await git(at, 'rev-parse', '--verify', '-q', 'refs/heads/main')) ? 'main' : (await git(at, 'rev-parse', '--verify', '-q', 'refs/heads/master')) ? 'master' : undefined
  if (!main) return undefined
  const ahead = await git(at, 'rev-list', '--count', `${main}..${tree.branch}`)
  if (ahead === undefined) return undefined
  if (ahead !== '0') return false
  const moves = await git(at, 'reflog', 'show', '--format=%H', `refs/heads/${tree.branch}`)
  return moves ? moves.split('\n').length > 1 : undefined
}

const FILES = 30
/**
 * What a branch changed since it left main, merged or not: from the commit it was last rebased onto, else the one it was
 * made at (its reflog), to its tip. Committed work only.
 */
async function changesOf(at: string, branch: string): Promise<Changes | undefined> {
  const log = (await git(at, 'reflog', 'show', '--format=%H %gs', `refs/heads/${branch}`) || undefined)?.split('\n')
  if (!log) return undefined
  const base = log.map((l) => / onto ([0-9a-f]{40})$/.exec(l)?.[1]).find(Boolean) ?? log.at(-1)!.split(' ')[0]
  // Three dots: from where the two meet, should the base not be an ancestor any more (a reset).
  const out = await git(at, 'diff', '--numstat', `${base}...refs/heads/${branch}`)
  if (out === undefined) return undefined
  const files = out.split('\n').filter(Boolean).map((l) => {
    const [added, removed, ...path] = l.split('\t')
    // Binary files count no lines ("-").
    return { path: path.join('\t'), added: Number(added) || 0, removed: Number(removed) || 0 }
  })
  const sum = (k: 'added' | 'removed') => files.reduce((n, f) => n + f[k], 0)
  return { files: files.slice(0, FILES), added: sum('added'), removed: sum('removed'), ...(files.length > FILES ? { more: files.length - FILES } : {}) }
}

const ANSWER = 4_000
/** How a child stands as a report, if it's one: it answered, failed, or waits on a question. Not while it works or signs in. */
function outcomeOf(t: ThreadInfo, now: number): Report['outcome'] | undefined {
  const { state, kind } = t.status
  if (state === 'working' || (state === 'blocked' && kind === 'auth') || (state === 'idle' && running(t, now))) return undefined
  return state === 'blocked' ? 'question' : state === 'error' ? 'error' : 'done'
}

type Entry = { kind: string; model?: readonly unknown[] }
/** The tool call a thread is in now, from its newest entries: its name and what it's on (a command, a path). */
function callOf(entries: readonly Entry[]) {
  const done = new Set<string>()
  for (const entry of entries) {
    for (const message of (entry.model ?? []) as { role?: string; toolCallId?: string; content?: unknown }[]) {
      if (message.role === 'toolResult' && message.toolCallId) done.add(message.toolCallId)
      if (message.role !== 'assistant' || !Array.isArray(message.content)) continue
      for (const block of message.content as { type: string; id?: string; name?: string; arguments?: Record<string, unknown> }[]) {
        if (block.type !== 'toolCall' || !block.id || done.has(block.id)) continue
        const args = block.arguments ?? {}
        const on = [args.command, args.path, args.id, args.title].find((v) => typeof v === 'string') as string | undefined
        return on ? `${block.name} (\`${on.split('\n')[0]!.slice(0, 80)}\`)` : block.name
      }
      return undefined
    }
  }
  return undefined
}

export function staff({ tickMs = 30_000, stallMs = 15 * MINUTE, cap = 4 }: StaffOptions = {}) {
  return defineDaemonExtension({
    ...about,
    setup(superego) {
      const state = superego.state<State>()
      const isLead = (t: ThreadInfo) => t.profile?.name === PROFILE && !t.archived
      /** What each lead's board shows besides what the window knows of threads. */
      const board = superego.scopedValue<Board>(BOARD, EMPTY_BOARD)
      /** The stall each child was last reported for (its activity then), so it's told once. */
      const warned = new Map<string, number>()
      const tell = (lead: string, message: string) => superego.threads.send(lead, message, { whenBusy: 'followUp' })
      /** The thread a tool call's conversation is. */
      const threadOf = (conversationId: number) => superego.threads.of(conversationId)
      const answerOf = (id: string) => superego.threads.lastAnswer(id).catch(() => undefined)

      /** Each worktree child's changes, worked out again only when it moved on and its branch's tip with it. */
      const known = new Map<string, { activeAt: number; tip?: string; changes?: Changes }>()
      async function changes(t: ThreadInfo) {
        const tree = branchOf(t)
        if (!tree) return undefined
        const last = known.get(t.id)
        if (last?.activeAt === t.activeAt) return last.changes
        const tip = await git(tree.at, 'rev-parse', '-q', '--verify', `refs/heads/${tree.branch}`)
        const next = tip && tip === last?.tip ? last.changes : tip ? await changesOf(tree.at, tree.branch) : undefined
        known.set(t.id, { activeAt: t.activeAt, tip, changes: next })
        return next
      }

      /** A child's report as it stands: what it said (its answer, error or question) and what its branch changed. */
      async function reportOf(child: ThreadInfo, outcome: Report['outcome'], at: number): Promise<Report | undefined> {
        const answer = outcome === 'done' ? await answerOf(child.id) : child.status.msg
        // Idle with nothing said: not started yet, more likely than finished.
        if (!answer && child.status.state === 'idle') return undefined
        const tree = branchOf(child)
        const [changed, merged] = tree ? await Promise.all([changes(child), mergedOf(child)]) : []
        return {
          id: child.id, title: child.title, at, outcome, answer: (answer ?? '').trim().slice(0, ANSWER),
          ...(tree ? { branch: tree.branch } : {}), ...(changed ? { changes: changed } : {}), ...(merged !== undefined ? { merged } : {}),
        }
      }

      async function start(lead: ThreadInfo, { worktree, ...args }: Start) {
        // A worktree is asked of the worktrees extension by name.
        const options = worktree !== undefined ? { options: { worktrees: worktree } } : {}
        return await superego.threads.start({ ...args, cwd: args.cwd ?? lead.cwd, parent: lead.id, ...options })
      }

      async function tick() {
        const all = await superego.threads.list()
        const at = Date.now()
        const leads = all.filter(isLead)
        for (const lead of leads) {
          if (superego.signal.aborted) return
          // One lead's trouble doesn't keep the others from their tick.
          try { await tickLead(lead) } catch (error) { console.error(`staff: tick failed for lead ${lead.id}:`, error) }
        }
        for (const id of known.keys()) if (!all.some((t) => t.id === id && !t.archived)) known.delete(id)
        for (const id of board.scopes()) if (!leads.some((l) => l.id === id)) board.delete(id)

        async function tickLead(lead: ThreadInfo) {
          const children = all.filter((t) => t.parent === lead.id && !t.archived)
          let mine = (await state.get(lead.id)) ?? {}
          const notes: string[] = []

          // Check-ins that are due.
          const due = (mine.checkIns ?? []).filter((c) => c.at <= at)
          if (due.length) {
            await state.update(lead.id, (s) => ({ ...s, checkIns: (s?.checkIns ?? []).filter((c) => c.at > at) }))
            notes.push(...due.map((c) => `Check-in: ${c.note}`))
          }

          // The watchdog: a working child with nothing new for too long. Reported once per stall; never stopped.
          const stalled: Board['stalled'] = {}
          for (const child of children) {
            if (child.status.state !== 'working' || at - child.activeAt < stallMs) { warned.delete(child.id); continue }
            const call = callOf(await superego.threads.entries(child.id, 10).catch(() => []) as unknown as Entry[])
            stalled[child.id] = { since: child.activeAt, ...(call ? { call } : {}) }
            if (warned.get(child.id) === child.activeAt) continue
            warned.set(child.id, child.activeAt)
            notes.push(`Watchdog: ${linkTo(child)} has made no progress for ${minutes(at - child.activeAt)}${call ? `, in ${call}` : ''}.`)
          }

          // Reports: a child that answered, failed or came to wait on a question since it was last reported. Seen on the
          // tick, as thread-reports tells the lead; kept (one a child, the newest) until the user dismisses it.
          for (const child of children) {
            const outcome = outcomeOf(child, at)
            if (!outcome || (mine.reported?.[child.id] ?? -1) >= child.activeAt) continue
            const report = await reportOf(child, outcome, at)
            if (!report) continue
            const live = new Set(children.map((c) => c.id))
            await state.update(lead.id, (s) => ({
              ...s,
              reports: [report, ...(s?.reports ?? []).filter((r) => r.id !== child.id)],
              // Archived children won't report again: forget them.
              reported: Object.fromEntries([...Object.entries(s?.reported ?? {}).filter(([id]) => live.has(id)), [child.id, child.activeAt]]),
            }))
            mine = (await state.get(lead.id)) ?? {}
          }

          // What each worktree child's branch has changed so far.
          const changed: Board['changes'] = {}
          for (const child of children) {
            const c = await changes(child)
            if (c?.files.length) changed[child.id] = c
          }

          // Queued starts, as slots free up.
          mine = (await state.get(lead.id)) ?? {}
          let slots = cap - children.filter((t) => running(t, at)).length
          while (slots > 0 && mine.queue?.length) {
            const [next, ...rest] = mine.queue
            await state.update(lead.id, (s) => ({ ...s, queue: rest }))
            mine = { ...mine, queue: rest }
            try {
              const child = await start(lead, next!.args)
              notes.push(`Started ${linkTo(child)} (id ${child.id}) from the queue${rest.length ? `; ${rest.length} still queued` : ''}.`)
              slots--
            } catch (error) {
              notes.push(`Couldn't start the queued "${next!.args.title ?? 'thread'}": ${error instanceof Error ? error.message : String(error)}`)
            }
          }

          if (superego.signal.aborted) return
          board.set(lead.id, {
            stalled, queued: (mine.queue ?? []).map((q) => ({ title: q.args.title ?? q.args.prompt.slice(0, 60), at: q.at })),
            changes: changed, reports: mine.reports ?? [],
          })
          if (notes.length) await tell(lead.id, notes.join('\n\n'))
        }
      }

      // One tick at a time; a failed one is logged and the next tries again.
      let ticking: Promise<void> | undefined
      const poke = () => {
        ticking ??= tick().catch((error) => console.error('staff: tick failed:', error)).finally(() => { ticking = undefined })
        return ticking
      }
      const timer = setInterval(poke, tickMs)
      // Not awaited: setup stays quick, and doesn't wait on threads (whose profiles may be loading).
      const first = setTimeout(poke, 0)
      superego.signal.addEventListener('abort', () => { clearInterval(timer); clearTimeout(first) })

      superego.agent(defineExtension({
        name: 'staff',
        tools: [defineTool({
          name: 'check_in',
          description: 'Schedule a message to this thread, "Check-in: <note>", in `minutes`: to look at running work later instead of ' +
            'blocking on thread_read (wait: true). It survives a restart.',
          parameters: obj({ minutes: num({ minimum: 0 }), note: str({ minLength: 1 }) }),
          async execute({ minutes: after, note }, api) {
            const id = threadOf(api.conversationId)
            if (!id) throw new Error('Only a thread can check in')
            const at = Date.now() + after * MINUTE
            await state.update(id, (s) => ({ ...s, checkIns: [...(s?.checkIns ?? []), { at, note }] }))
            return text(`Check-in set for ${new Date(at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}.`)
          },
        })],
        // thread_start beyond the cap queues the start; it's made when a child finishes.
        wraps: [wrapTool({ name: 'thread_start' } as never, (tool: any) => ({
          ...tool,
          async execute(args: Start, api: { conversationId: number }, context: unknown) {
            const id = threadOf(api.conversationId)
            const all = id ? await superego.threads.list() : []
            const lead = all.find((t) => t.id === id)
            const busy = lead ? all.filter((t) => t.parent === lead.id && running(t, Date.now())).length : 0
            const queued = lead ? ((await state.get(lead.id))?.queue ?? []).length : 0
            if (!lead || (busy < cap && !queued)) return tool.execute(args, api, context)
            await state.update(lead.id, (s) => ({ ...s, queue: [...(s?.queue ?? []), { args, at: Date.now() }] }))
            void poke()
            return text(`Queued (${busy} running${queued ? `, ${queued} queued before it` : ''}): it starts when a slot frees up, and you'll be told.`)
          },
        }))],
      }))

      // Each live child's last answer in a line, and whether its branch is merged; the merges of reported ones, archived too.
      superego.method('staff.details', async ({ id }): Promise<Details[]> => {
        const children = (await superego.threads.list()).filter((t) => t.parent === id)
        const gone = ((await state.get(id))?.reports ?? []).filter((r) => r.branch && !children.some((c) => c.id === r.id))
        const archived = (await Promise.all(gone.map((r) => superego.threads.get(r.id).catch(() => undefined)))).filter((t) => t !== undefined)
        return Promise.all([...children, ...archived].map(async (child) => {
          const answer = child.archived ? undefined : await answerOf(child.id)
          const merged = await mergedOf(child)
          return { id: child.id, answer: answer?.split('\n').find((l) => l.trim())?.slice(0, 160) ?? null, merged: merged ?? null }
        }))
      }, { params: obj({ id: str() }) })

      // The user's done with a report (or, without `child`, all of a lead's): off the board, and out of its state.
      superego.action(defineAction({
        id: 'staff.dismiss', title: 'Dismiss a report on the board', expose: ['ui'],
        params: obj({ id: str(), child: opt(str()) }),
        async run({ id, child }) {
          const keep = (r: Report) => child !== undefined && r.id !== child
          await state.update(id, (s) => ({ ...s, reports: (s?.reports ?? []).filter(keep) }))
          board.update(id, (b) => ({ ...b, reports: b.reports.filter(keep) }))
          return null
        },
      }))
    },
  })
}

export default staff()
