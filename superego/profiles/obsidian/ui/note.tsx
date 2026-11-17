// The note pane: a note as Obsidian shows it, live preview to read and edit in one place (Superego's file editor), and
// the notes linking to it below. Show in graph centres the graph on it.
// [[wikilinks]] are this profile's: anywhere in its threads (a message, ⌃O, a note), [[Note#Heading|alias]] opens the
// note pane on the note the vault's rules find (a path, a title anywhere in the vault, an alias), at that heading.
import { Button, FileEditor, has, PaneMessage, useDispatch, useMethod, type PaneProps } from 'superego/ui'
import type { NoteInfo } from '../shared.ts'

type Params = { path?: string; heading?: string; block?: string }

export function NotePane({ machine, thread, pane }: PaneProps) {
  const dispatch = useDispatch()
  const { path, heading, block } = (pane.params ?? {}) as Params
  const open = (kind: string, params: Record<string, unknown>, title?: string) => void dispatch('pane.open', { thread: thread.id, kind, params, ...(title ? { title } : {}) }, { machine: machine.id })
  // Which note (a [[name]] resolves as Obsidian would) and what links to it, again as the thread moves on.
  const { data: note, error } = useMethod<NoteInfo>(machine.id, 'vault.note', { thread: thread.id, path, ...(heading ? { heading } : {}), ...(block ? { block } : {}) },
    { enabled: Boolean(path) && has(machine, 'ext:vault@^1'), refresh: thread.activeAt })

  if (!path) return <PaneMessage>No note given.</PaneMessage>
  if (error) return <PaneMessage>{error.message}</PaneMessage>
  if (!note) return <PaneMessage>Reading…</PaneMessage>
  return (
    <FileEditor key={note.path} machine={machine} thread={thread} path={note.path} {...(note.line ? { line: note.line } : {})}
      actions={<Button onClick={() => open('graph', { focus: note.path })}>Show in graph</Button>}>
      {note.backlinks.length > 0 && (
        <div className="vault-note__backlinks">
          <h3>Linked from</h3>
          {note.backlinks.map((b) => <a key={b.path} href="#" onClick={(e) => { e.preventDefault(); open('note', { path: b.path }, b.title) }}>{b.title}</a>)}
        </div>
      )}
    </FileEditor>
  )
}

/** The note pane's title: the note's name. */
export const noteTitle = (pane: { params?: unknown }) => (pane.params as Params | undefined)?.path?.split('/').at(-1)?.replace(/\.md$/, '') ?? 'Note'
