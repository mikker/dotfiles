// vault, UI half: the graph and note panes, and [[wikilinks]] in this profile's threads opening the note the vault finds.
import { call, defineUiExtension, parseWikilink } from 'superego/ui'
import { about, type NoteInfo } from '../shared.ts'
import { GraphPane } from './graph.tsx'
import { NotePane, noteTitle } from './note.tsx'

export default defineUiExtension({
  ...about,
  setup(superego) {
    superego.pane('graph', { title: 'Graph', component: GraphPane, menu: true })
    // Notes named in the thread ([[GitHub]], `Work/GitHub/GitHub.md`) open in the note pane.
    superego.pane('note', { title: noteTitle, component: NotePane, opens: (path) => /\.md$/i.test(path) })
    // [[wikilinks]], ahead of the core's (which looks for a file of that name): the note the vault finds, in the note
    // pane, at its heading. Why not, if the vault has no such note.
    superego.link({
      match: 'wikilink:',
      async open(href, { machine, thread }) {
        const link = parseWikilink(href)
        if (!machine || !thread || !link?.target) return 'not a note'
        const params = { path: link.target, ...(link.heading ? { heading: link.heading } : {}), ...(link.block ? { block: link.block } : {}) }
        try {
          const found = await call<NoteInfo>(machine, 'vault.note', { thread: thread.id, ...params })
          await superego.dispatch('pane.open', { thread: thread.id, kind: 'note', title: found.title, params: { ...params, path: found.path } }, { machine })
          return undefined
        } catch (error) { return (error as Error).message }
      },
      target: (href) => { const link = parseWikilink(href); return link ? `${link.target}${link.heading ? ` › ${link.heading}` : ''}` : href },
    })
    const style = document.createElement('style')
    style.textContent = `
      .vault-graph { flex: 1; display: flex; flex-direction: column; min-height: 0; }
      .vault-graph__canvas { flex: 1; width: 100%; min-height: 0; cursor: grab; touch-action: none; }
      .vault-graph__legend { display: flex; gap: 10px; flex-wrap: wrap; justify-content: flex-end; font-size: 12px; color: var(--superego-muted); }
      .vault-graph__legend i { display: inline-block; width: 8px; height: 8px; border-radius: 50%; margin-right: 4px; }
      .vault-note__backlinks { margin-top: 8px; padding-top: 12px; border-top: 1px solid var(--superego-border); display: flex; flex-wrap: wrap; gap: 6px 14px; font-size: 13px; }
      .vault-note__backlinks a { color: var(--superego-accent); text-decoration: none; }
      .vault-note__backlinks h3 { width: 100%; margin: 0 0 4px; font-size: 12px; color: var(--superego-muted); font-weight: 600; }
    `
    document.head.append(style)
    return () => style.remove()
  },
})
