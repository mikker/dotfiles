// staff in a real daemon (superego/testing's), on short timers: the watchdog over a child stuck in a tool call, check-ins
// (across a restart too), the cap queueing thread_start, and reports (with a real git repository for a child's branch)
// kept past the child's archive until dismissed from the board. `superego extension test --user -P chief-of-staff`.
import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { afterEach, expect, it } from 'vitest'
import type { ThreadInfo } from 'superego'
import { callTool, mountUi, say, testDaemon, type TestDaemon, type TestWindow } from 'superego/testing'
import board from '../board.tsx'
import type { StaffOptions } from '../staff.ts'
import { BOARD, PANE, type Board, type Details } from '../shared.ts'

const here = new URL('.', import.meta.url).pathname

/**
 * The profile as the real one, with staff on test timers, and stand-ins for the bundled extensions it leans on, which a
 * test daemon hasn't: thread-tools' thread_start for it to wrap, worktrees' facts, and agent-ui's ask_user (stand-ins.ts). Its board is a
 * copy, as the window loads a profile's UI only from inside its folder.
 */
const source = (file: string) => readFileSync(join(here, '..', file), 'utf8')
const profile = (options: StaffOptions) => ({
  'profile.ts': `import { defineProfile } from 'superego'\nexport default defineProfile({ extensions: ['./staff.ts', './thread-tools.ts', './worktrees.ts', './agent-ui.ts'], ui: ['./board.tsx'] })\n`,
  'board.tsx': source('board.tsx'),
  'shared.ts': source('shared.ts'),
  'staff.ts': `import { staff } from ${JSON.stringify(join(here, '..', 'staff.ts'))}\nexport default staff(${JSON.stringify(options)})\n`,
  'thread-tools.ts': `export { threadTools as default } from ${JSON.stringify(join(here, 'stand-ins.ts'))}\n`,
  'worktrees.ts': `export { worktrees as default } from ${JSON.stringify(join(here, 'stand-ins.ts'))}\n`,
  'agent-ui.ts': `export { agentUi as default } from ${JSON.stringify(join(here, 'stand-ins.ts'))}\n`,
})

let daemon: TestDaemon | undefined
let window: TestWindow | undefined
const cleanups: (() => unknown)[] = []
afterEach(async () => {
  await window?.unmount()
  await daemon?.close()
  for (const cleanup of cleanups.splice(0)) await cleanup()
  window = daemon = undefined
})

const up = async (options: StaffOptions, model: NonNullable<Parameters<typeof testDaemon>[0]>['model']) =>
  daemon = await testDaemon({ profileName: 'chief-of-staff', profile: profile(options), model })
const said = async (thread: string, text: string) => (await daemon!.transcript(thread)).split(text).length - 1
const childrenOf = async (lead: string) => (await daemon!.call<ThreadInfo[]>('thread.list', {})).filter((t) => t.parent === lead)

it('tells the lead once when a working child has made no progress for a while, and in which tool call', async () => {
  // The child sits in a 3s bash call: stalled after 1s. The lead hears it (and answers), then the child finishes.
  await up({ tickMs: 100, stallMs: 1_000 }, [callTool('bash', { command: 'sleep 3' }), say('Noted.'), say('Smoke done.')])
  const lead = await daemon!.thread(undefined, { title: 'Lead' })
  const watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  const smoke = await daemon!.call<ThreadInfo>('thread.start', { parent: lead.id, title: 'Smoke', prompt: 'Run the smoke' })
  await watched.until((b) => Boolean(b.stalled[smoke.id]), 'the stall on the board')
  expect(watched.value.stalled[smoke.id]).toMatchObject({ call: 'bash (`sleep 3`)' })
  const told = `Watchdog: [Smoke](thread:${smoke.id}) has made no progress for 1 min, in bash (\`sleep 3\`).`
  await daemon!.until(async () => (await said(lead.id, told)) > 0, 'the lead told')
  const once = await said(lead.id, told)

  // Done: off the stalled list, reported, and not told again.
  await daemon!.idle(smoke.id)
  await watched.until((b) => b.reports.length === 1 && !b.stalled[smoke.id], 'its report')
  expect(watched.value.reports[0]).toMatchObject({ id: smoke.id, title: 'Smoke', outcome: 'done', answer: 'Smoke done.' })
  expect(await said(lead.id, 'Watchdog')).toBe(once)
}, 20_000)

it('fires a check-in when it falls due, after a restart too', async () => {
  // Looking only once it's set up: the check-in can't come before the restart.
  await up({ tickMs: 600_000 }, [callTool('check_in', { minutes: 0.05, note: 'Look at the lanes' }), say('Set.')])
  const lead = await daemon!.thread('go', { title: 'Lead' })
  expect(await daemon!.transcript(lead.id)).toContain('Check-in set for')
  // Past when it was due; up again, it comes.
  await new Promise((r) => setTimeout(r, 3_500))
  daemon = await daemon!.restart({ model: [say('Looked.')] })
  await daemon.until(async () => (await daemon!.transcript(lead.id)).includes('Looked.'), 'the check-in answered', 20_000)
  expect(await daemon.transcript(lead.id)).toContain('Check-in: Look at the lanes')
}, 40_000)

it('queues thread_start beyond the cap, and starts the queued as a child finishes', async () => {
  await up({ tickMs: 100, cap: 1 }, [
    callTool('thread_start', { prompt: 'Do A', title: 'A' }), callTool('thread_start', { prompt: 'Do B', title: 'B' }), say('One started, one queued.'),
    // B's first turn and the lead's, in either order.
    say('Ok.'), say('Ok.'),
  ])
  const lead = await daemon!.thread('Start A and B', { title: 'Lead' })
  const transcript = await daemon!.transcript(lead.id)
  expect(transcript).toContain('Started A')
  expect(transcript).toContain("Queued (1 running): it starts when a slot frees up, and you'll be told.")
  const watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  await watched.until((b) => b.queued.map((q) => q.title).join() === 'B', 'B queued on the board')

  // A is done with: B starts, in the lead's folder, as its child; the lead is told.
  const [a] = await childrenOf(lead.id)
  await daemon!.dispatch('thread.archive', { thread: a!.id })
  await daemon!.until(async () => (await said(lead.id, 'from the queue.')) > 0, 'the lead told of B')
  const [b] = await childrenOf(lead.id)
  expect(b).toMatchObject({ title: 'B', cwd: lead.cwd })
  expect(await daemon!.transcript(lead.id)).toContain(`Started [B](thread:${b!.id}) (id ${b!.id}) from the queue.`)
  await watched.until((x) => x.queued.length === 0, 'the queue empty')
}, 20_000)

it("reports a child with its branch's changes, keeps it past the archive, and drops it when dismissed on the board", async () => {
  // A repository, and a child's worktree on a branch of its own: it commits, main moves on, it rebases and merges.
  const dir = mkdtempSync(join(tmpdir(), 'staff-repo-'))
  cleanups.push(() => rmSync(dir, { recursive: true, force: true }))
  const repo = join(dir, 'main')
  const tree = join(dir, 'lane')
  const git = (cwd: string, ...args: string[]) => execFileSync('git', ['-C', cwd, '-c', 'user.name=t', '-c', 'user.email=t@t', ...args], { encoding: 'utf8' })
  execFileSync('git', ['init', '-q', '-b', 'main', repo])
  writeFileSync(join(repo, 'a.txt'), 'one\ntwo\n')
  git(repo, 'add', '.'); git(repo, 'commit', '-qm', 'a')
  git(repo, 'worktree', 'add', '-q', '-b', 'superego/lane', tree, 'HEAD')
  writeFileSync(join(tree, 'a.txt'), 'one\nTWO\nthree\n')
  writeFileSync(join(tree, 'b.txt'), 'b\n')
  git(tree, 'add', '.'); git(tree, 'commit', '-qm', 'lane')

  await up({ tickMs: 100 }, [say('Did the lane.\nAll green.')])
  const lead = await daemon!.thread(undefined, { title: 'Lead', cwd: repo })
  const watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  // Of this profile, so the stand-in worktrees (a profile's extension) gives it one.
  const lane = await daemon!.call<ThreadInfo>('thread.start', { parent: lead.id, title: 'Lane', cwd: repo, profile: 'chief-of-staff', options: { worktrees: { path: tree, branch: 'superego/lane' } } })

  // Started, not yet run: the board shows what its branch changed so far, and no report.
  await watched.until((b) => b.changes[lane.id]?.added === 3, 'its changes')
  expect(watched.value.changes[lane.id]).toMatchObject({ added: 3, removed: 1 })
  expect(watched.value.reports).toEqual([])

  // Main moves on; it rebases, merges and finishes: reported once, with only its own changes, merged.
  writeFileSync(join(repo, 'c.txt'), 'c\n')
  git(repo, 'add', '.'); git(repo, 'commit', '-qm', 'c')
  git(tree, 'rebase', '-q', 'main')
  git(repo, 'merge', '-q', '--ff-only', 'superego/lane')
  await daemon!.send(lane.id, 'Finish it')
  await watched.until((b) => b.reports.length === 1, 'its report')
  expect(watched.value.reports[0]).toMatchObject({
    id: lane.id, title: 'Lane', outcome: 'done', answer: 'Did the lane.\nAll green.', branch: 'superego/lane', merged: true,
    changes: { added: 3, removed: 1, files: [{ path: 'a.txt', added: 2, removed: 1 }, { path: 'b.txt', added: 1, removed: 0 }] },
  })

  // Archived (as the lead does once it's read the report), it stays on the board; the details still say it's merged.
  await daemon!.dispatch('thread.archive', { thread: lane.id })
  await watched.until((b) => !b.changes[lane.id], 'its changes gone with it')
  expect(watched.value.reports).toHaveLength(1)
  expect(await daemon!.call<Details[]>('staff.details', { id: lead.id })).toEqual([{ id: lane.id, answer: null, merged: true }])

  // On the board, under Landed; dismissed there: gone, and not reported again.
  window = await mountUi({ machines: [daemon!], profile: { ref: lead.profile!, extensions: [board] }, select: { thread: lead.id } })
  const pane = await window.render({ pane: { kind: PANE }, thread: lead.id })
  await window.until(() => pane.text().includes('Did the lane.'), 'the report on the board')
  expect(pane.text()).toContain('Landed')
  expect(pane.text()).toContain('merged')
  await pane.click('button[aria-label="Dismiss"]')
  await watched.until((b) => b.reports.length === 0, 'dismissed')
  await window.until(() => pane.text().includes('No threads started yet.'), 'the board empty')
  await new Promise((r) => setTimeout(r, 300))
  expect(watched.value.reports).toEqual([])
}, 30_000)

it('takes a later report over an earlier one, and dismisses all at once', async () => {
  await up({ tickMs: 100 }, 'echo')
  const lead = await daemon!.thread(undefined, { title: 'Lead' })
  const watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  const one = await daemon!.call<ThreadInfo>('thread.start', { parent: lead.id, title: 'One', prompt: 'First from one' })
  await daemon!.idle(one.id)
  const two = await daemon!.call<ThreadInfo>('thread.start', { parent: lead.id, title: 'Two', prompt: 'From two' })
  await daemon!.idle(two.id)
  await watched.until((b) => b.reports.length === 2, 'both reported')
  expect(watched.value.reports.map((r) => [r.title, r.answer]).sort()).toEqual([['One', 'echo: First from one'], ['Two', 'echo: From two']])
  // One answers again: its report says so now, first, in place of the earlier.
  await daemon!.send(one.id, 'Then from one')
  await watched.until((b) => b.reports[0]?.answer === 'echo: Then from one', 'the later report')
  expect(watched.value.reports.map((r) => [r.title, r.answer])).toEqual([['One', 'echo: Then from one'], ['Two', 'echo: From two']])
  await daemon!.dispatch('staff.dismiss', { id: lead.id })
  await watched.until((b) => b.reports.length === 0, 'all dismissed')
  await new Promise((r) => setTimeout(r, 300))
  expect(watched.value.reports).toEqual([])
})

it('lays out the plan and puts decisions on the board, answered there by number after a moment to take it back', async () => {
  await up({ tickMs: 100 }, [
    callTool('board_plan', { title: 'Colony polish', summary: 'Wave 1 is under way.', waves: [{ title: 'Feel', lanes: ['Ranger feel', 'Sound'] }] }),
    callTool('board_ask', { question: 'Worth a sprite?', options: ['Own sprite', { label: 'Keep the pill', description: 'as now' }], about: ['Ranger feel'] }),
    callTool('board_ask', { question: 'Ship the lookbook?', options: ['Yes', 'No'] }),
    say('On the board.'),
    // The lead's turns for the answers it's told.
    say('Noted.'), say('Noted.'),
  ])
  const lead = await daemon!.thread('Plan it', { title: 'Lead' })
  const watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  await watched.until((b) => b.decisions.length === 2 && Boolean(b.plan), 'the plan and decisions')
  expect(watched.value.plan).toMatchObject({ title: 'Colony polish', waves: [{ title: 'Feel', lanes: ['Ranger feel', 'Sound'] }] })
  const [sprite, ship] = watched.value.decisions
  expect(sprite).toMatchObject({ question: 'Worth a sprite?', options: [{ label: 'Own sprite' }, { label: 'Keep the pill', description: 'as now' }], about: ['Ranger feel'] })
  expect(await daemon!.transcript(lead.id)).toContain(`Decision ${sprite!.id} is on the board.`)

  window = await mountUi({ machines: [daemon!], profile: { ref: lead.profile!, extensions: [board] }, select: { thread: lead.id } })
  const pane = await window.render({ pane: { kind: PANE }, thread: lead.id })
  await window.until(() => pane.text().includes('Worth a sprite?'), 'the decision on the board')
  expect(pane.text()).toContain('Colony polish')
  expect(pane.text()).toContain('Wave 1 · Feel')
  expect(pane.text()).toContain('2 need you')
  pane.find('.staff-board')!.focus()

  // The cursor starts on the first; 1 picks, z takes it back: nothing goes.
  await window.key('1')
  expect(pane.text()).toContain('Sending “Own sprite”')
  await window.key('z')
  expect(pane.text()).not.toContain('Sending')
  // 2 picks, and after a moment it's sent: the lead hears it, and the board keeps it, answered.
  await window.key('2')
  // (The transcript is JSON: the message's newline is in it as \n.)
  await daemon!.until(async () => (await said(lead.id, `Decision ${sprite!.id}: Worth a sprite?\\n→ Keep the pill`)) > 0, 'the lead told')
  expect(await said(lead.id, '→ Own sprite')).toBe(0)
  await watched.until((b) => b.decisions[0]?.answer?.text === 'Keep the pill', 'answered on the board')
  await window.until(() => pane.text().includes('→ Keep the pill'), 'shown answered')

  // n goes to the next open one; r answers it in words.
  await window.key('n')
  await window.key('r')
  await window.type('.staff-board__reply', 'Not yet')
  await window.key('enter')
  await daemon!.until(async () => (await said(lead.id, `Decision ${ship!.id}: Ship the lookbook?\\n→ Not yet`)) > 0, 'the words sent')

  // x on an answered one dismisses it; an answer twice is refused.
  await expect(daemon!.dispatch('staff.decide', { id: lead.id, decision: sprite!.id, text: 'Own sprite' })).rejects.toThrow('already answered')
  await window.key('k')
  await window.key('x')
  await watched.until((b) => b.decisions.length === 1, 'dismissed')
  expect(watched.value.decisions[0]!.id).toBe(ship!.id)
}, 30_000)

it('keeps the plan and decisions across a restart, and lets the lead close one', async () => {
  await up({ tickMs: 100 }, [
    callTool('board_ask', { question: 'Migrate v2 saves?', options: ['Yes', 'No'] }), say('Asked.'),
  ])
  const lead = await daemon!.thread('Ask', { title: 'Lead' })
  let watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  await watched.until((b) => b.decisions.length === 1, 'the decision')
  const { id } = watched.value.decisions[0]!
  daemon = await daemon!.restart({ model: [callTool('board_close', { id, note: 'Settled in chat: wipe' }), say('Closed.')] })
  watched = await daemon.watch<Board>(BOARD, { scope: lead.id })
  await watched.until((b) => b.decisions.length === 1, 'the decision after the restart')
  await daemon.send(lead.id, 'Close it')
  await watched.until((b) => b.decisions[0]?.answer?.by === 'lead', 'closed')
  expect(watched.value.decisions[0]!.answer!.text).toBe('Settled in chat: wipe')
}, 30_000)

it("answers a child's own question on the board, and tells the lead", async () => {
  await up({ tickMs: 100 }, [callTool('ask_user', { question: 'Keep v2 saves loadable?', options: ['Migrate', 'Wipe'] }), say('Ok.'), say('Ok.')])
  const lead = await daemon!.thread(undefined, { title: 'Lead' })
  // Of this profile, so it has the stand-in ask_user (a profile's extension).
  const save = await daemon!.call<ThreadInfo>('thread.start', { parent: lead.id, title: 'Save v3', prompt: 'Do the save format', profile: 'chief-of-staff' })
  window = await mountUi({ machines: [daemon!], profile: { ref: lead.profile!, extensions: [board] }, select: { thread: lead.id } })
  const pane = await window.render({ pane: { kind: PANE }, thread: lead.id })
  await window.until(() => pane.text().includes('Keep v2 saves loadable?'), "the child's question on the board", 10_000)
  pane.find('.staff-board')!.focus()
  await window.key('2')
  await daemon!.until(async () => (await said(lead.id, '→ Wipe')) > 0, 'the lead told')
  expect(await daemon!.transcript(lead.id)).toContain(`On the board, the user answered [Save v3](thread:${save.id}): Keep v2 saves loadable?`)
  await window.until(() => !pane.text().includes('Keep v2 saves loadable?'), 'the question gone')
}, 30_000)

it('takes the focus as the window goes to its pane, so keys work at once', async () => {
  await up({ tickMs: 100 }, [callTool('board_ask', { question: 'Worth a sprite?', options: ['Yes', 'No'] }), say('Asked.')])
  const lead = await daemon!.thread('Ask', { title: 'Lead' })
  const watched = await daemon!.watch<Board>(BOARD, { scope: lead.id })
  await watched.until((b) => b.decisions.length === 1, 'the decision')
  window = await mountUi({ machines: [daemon!], profile: { ref: lead.profile!, extensions: [board] }, select: { thread: lead.id }, window: true })
  // Opened from the window, as the lead opens it: the window focuses the pane, and the pane its board.
  await window.dispatch('pane.open', { thread: lead.id, kind: PANE })
  await window.until(() => document.activeElement?.classList.contains('staff-board') ?? false, 'the board focused')
  await window.key('1')
  expect(window.window!.text()).toContain('Sending “Yes”')
  // Taken back: unmounted with it pending, the board would send it as the window goes.
  await window.key('z')
}, 20_000)
