// What vault is, for both halves (spread into each), and the shapes they share.
export const about = {
  name: 'vault', version: '1.0.0', api: '^4', title: 'Vault',
  panes: {
    graph: 'the vault as a graph of notes and their [[links]], coloured by top folder. Params: { focus?: "path/of/note.md" } centres it on a note.',
    note: 'a note rendered, its [[links]] clickable, with its backlinks. Params: { path: "path/of/note.md" }.',
  },
}

/** `vault.graph`: every note, and a link from one to another wherever it [[links]] or ![[embeds]] it. */
export type Graph = { nodes: { id: string; title: string; folder: string }[]; edges: { from: string; to: string }[] }

/** `vault.note`: a note the vault's rules find, what links to it, and the line of the heading or block asked for. */
export type NoteInfo = { path: string; title: string; content: string; backlinks: { path: string; title: string }[]; line?: number }
