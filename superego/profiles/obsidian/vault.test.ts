// vault's tools and reads over a tiny vault, in a real daemon (superego/testing's): search_notes ranks title matches
// first and leaves .obsidian out; backlinks finds links by path, by name and by alias; vault.note finds a heading's line.
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { dirname, join } from 'node:path'
import { afterEach, beforeEach, expect, it } from 'vitest'
import { callTools, say, testDaemon, type TestDaemon } from 'superego/testing'
import type { Graph, NoteInfo } from './shared.ts'

const profile = new URL('.', import.meta.url).pathname
const NOTES: Record<string, string> = {
  'Home.md': '# Home\nSee [[Projects/Alpha|alpha]] and [[Beta]].\n',
  'Projects/Alpha.md': '---\naliases: [A1]\n---\n# Alpha\nThe alpha project. More in [[Beta#Notes]].\n',
  'Beta.md': '# Beta\nIntro.\n## Notes\nBeta notes about alpha.\n',
  'Daily/2026-01-01.md': 'Met about [[A1]].\n',
  '.obsidian/workspace.md': 'alpha [[Beta]]\n',
}

let vault: string
let daemon: TestDaemon | undefined
beforeEach(async () => {
  vault = await mkdtemp(join(tmpdir(), 'vault-'))
  for (const [path, text] of Object.entries(NOTES)) {
    await mkdir(dirname(join(vault, path)), { recursive: true })
    await writeFile(join(vault, path), text)
  }
})
afterEach(async () => {
  await daemon?.close()
  daemon = undefined
  await rm(vault, { recursive: true, force: true })
})

/** What a tool answered, as the transcript (JSON) has it. */
const answered = (transcript: string, text: string) => transcript.includes(JSON.stringify(text).slice(1, -1))

it('searches notes, title matches first, and finds backlinks by path, name and alias', async () => {
  daemon = await testDaemon({
    profile,
    model: [
      callTools(
        { name: 'search_notes', args: { query: 'alpha' } },
        { name: 'search_notes', args: { query: 'alpha project', limit: 1 } },
        { name: 'search_notes', args: { query: 'gamma' } },
        { name: 'backlinks', args: { note: 'Alpha' } },
        { name: 'backlinks', args: { note: 'Beta' } },
        { name: 'backlinks', args: { note: 'Daily/2026-01-01' } },
        { name: 'backlinks', args: { note: 'Nope' } },
      ),
      say('Found them.'),
    ],
  })
  const thread = await daemon.thread('Look around', { cwd: vault })
  const transcript = await daemon.transcript(thread.id)
  expect(answered(transcript, 'Projects/Alpha.md — # Alpha\nBeta.md — Beta notes about alpha.\nHome.md — See [[Projects/Alpha|alpha]] and [[Beta]].')).toBe(true)
  expect(answered(transcript, 'Projects/Alpha.md — # Alpha')).toBe(true)
  expect(answered(transcript, 'No notes match.')).toBe(true)
  // [[Projects/Alpha|alpha]] by path, [[A1]] by its alias.
  expect(answered(transcript, 'Daily/2026-01-01.md\nHome.md')).toBe(true)
  // [[Beta]] by name, [[Beta#Notes]] at a heading; not .obsidian's.
  expect(answered(transcript, 'Home.md\nProjects/Alpha.md')).toBe(true)
  expect(answered(transcript, 'Nothing links to Daily/2026-01-01.md.')).toBe(true)
  expect(answered(transcript, 'No note Nope.')).toBe(true)
})

it('gives the panes the graph, and a note with its backlinks and the line of a heading', async () => {
  daemon = await testDaemon({ profile })
  const thread = await daemon.thread(undefined, { cwd: vault })
  // No turn yet: its profile loads now, as a window listing the thread would have it.
  await daemon.reload()
  const graph = await daemon.call<Graph>('vault.graph', { thread: thread.id })
  expect(graph.nodes.map((n) => n.id).sort()).toEqual(['Beta.md', 'Daily/2026-01-01.md', 'Home.md', 'Projects/Alpha.md'])
  expect(graph.edges).toHaveLength(4)
  const note = await daemon.call<NoteInfo>('vault.note', { thread: thread.id, path: 'Beta', heading: 'Notes' })
  expect(note).toMatchObject({ path: 'Beta.md', title: 'Beta', line: 3 })
  expect(note.backlinks.map((b) => b.path).sort()).toEqual(['Home.md', 'Projects/Alpha.md'])
  await expect(daemon.call('vault.note', { thread: thread.id, path: 'Nope' })).rejects.toThrow(/No note Nope/)
})
