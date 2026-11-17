// run's UI half over a real daemon: the header pill and the sidebar mark follow the folder's state, the output pane
// tails it with colours and its buttons stop and start it, and the pill opens the pane.
import { mkdtemp, mkdir, rm, writeFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { afterEach, beforeAll, expect, it } from 'vitest'
import { mountUi, testDaemon, type TestDaemon, type TestWindow } from 'superego/testing'
import ui from './ui.tsx'
import { LOGS_VIEW, STATUS, type RunStatus } from './shared.ts'

const profile = new URL('..', import.meta.url).pathname
beforeAll(() => { process.env.SHELL = '/bin/sh' })

let daemon: TestDaemon | undefined
let window: TestWindow | undefined
let folder: string | undefined
afterEach(async () => {
  await window?.unmount()
  await daemon?.close()
  if (folder) await rm(folder, { recursive: true, force: true })
  window = daemon = folder = undefined
})

it('shows the state in the header and the sidebar, and tails the output', async () => {
  folder = await mkdtemp(join(tmpdir(), 'run-ui-'))
  await mkdir(join(folder, '.superego'))
  await writeFile(join(folder, '.superego', 'run.json'), JSON.stringify({
    command: "sleep 0.4; echo READY; while true; do printf '\\033[31mred\\033[0m tick\\n'; sleep 0.1; done", ready: 'READY',
  }))
  daemon = await testDaemon({ profile })
  const thread = await daemon.thread(undefined, { cwd: folder })
  window = await mountUi({ machines: [daemon], profile: { ref: thread.profile!, extensions: [ui] }, select: { thread: thread.id } })
  const status = await daemon.watch<RunStatus>(STATUS, { scope: folder })

  // Configured, not running: a quiet pill, no mark.
  const header = await window.render({ view: 'run.pill', place: 'header', thread: thread.id })
  await window.until(() => header.text().includes('Run'), 'the idle pill')
  const badge = await window.render({ slot: 'thread.badge', thread: thread.id })
  expect(badge.find('.run-mark')).toBeNull()

  // The pane starts it.
  const pane = await window.render({ pane: { kind: LOGS_VIEW }, thread: thread.id })
  await window.until(() => pane.text().includes('Not started'), 'the empty pane')
  await pane.click('Start')
  await window.until(() => header.text().includes('Starting'), 'starting')
  expect(header.find('.run-pill.is-starting')).not.toBeNull()
  await status.until((s) => s.state === 'running', 'ready')
  await window.until(() => header.text().includes('Running') && Boolean(badge.find('.run-mark.is-running')), 'running')

  // Its output, in colour, as it comes.
  await window.until(() => pane.text().includes('red tick'), 'output')
  const red = [...pane.container.querySelectorAll('span')].find((s) => s.textContent === 'red')
  expect(red?.style.color).toBe('var(--run-c1)')

  await pane.click('Stop')
  await status.until((s) => s.state === 'stopped', 'stopped')
  await window.until(() => header.text().includes('Stopped') && !badge.find('.run-mark'), 'stopped in the window')

  // The pill opens the output pane.
  await header.click('Stopped')
  await daemon.until(async () => {
    const [info] = await daemon!.call<{ panes?: { kind: string }[] }[]>('thread.list', {}).then((list) => list.filter((t) => (t as { id?: string }).id === thread.id))
    return Boolean(info?.panes?.some((p) => p.kind === LOGS_VIEW))
  }, 'the output pane open')
})

it('shows nothing where there is no config', async () => {
  folder = await mkdtemp(join(tmpdir(), 'run-ui-'))
  daemon = await testDaemon({ profile })
  const thread = await daemon.thread(undefined, { cwd: folder })
  window = await mountUi({ machines: [daemon], profile: { ref: thread.profile!, extensions: [ui] }, select: { thread: thread.id } })
  const pane = await window.render({ pane: { kind: LOGS_VIEW }, thread: thread.id })
  await window.until(() => pane.text().includes('.superego/run.json'), 'how to add one')
  const header = await window.render({ view: 'run.pill', place: 'header', thread: thread.id })
  expect(header.text()).toBe('')
})

it('shows Run once a config is added, as the window comes back to the front', async () => {
  folder = await mkdtemp(join(tmpdir(), 'run-ui-'))
  daemon = await testDaemon({ profile })
  const thread = await daemon.thread(undefined, { cwd: folder })
  window = await mountUi({ machines: [daemon], profile: { ref: thread.profile!, extensions: [ui] }, select: { thread: thread.id } })
  const header = await window.render({ view: 'run.pill', place: 'header', thread: thread.id })
  const status = await daemon.watch<RunStatus>(STATUS, { scope: folder })
  await status.until((s) => s.config?.found === false, 'looked at: none')
  expect(header.text()).toBe('')

  await mkdir(join(folder, '.superego'))
  await writeFile(join(folder, '.superego', 'run.json'), JSON.stringify({ command: 'sleep 5' }))
  const dom = document.defaultView!
  dom.dispatchEvent(new dom.Event('focus'))
  await window.until(() => header.text().includes('Run'), 'the idle pill, without a turn or a reload')
})
