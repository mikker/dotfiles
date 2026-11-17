// The obsidian profile: an agent for an Obsidian vault. Start it in a vault: `superego -P obsidian` (or pick "obsidian" in
// the New thread dialog). The vault's own AGENTS.md is read into the instructions on every turn.
import { defineProfile } from 'superego'

export default defineProfile({
  description: 'Work in an Obsidian vault: find, read, file and link notes',
  prompt: [
    'You work in an Obsidian vault: a folder of Markdown notes linked with [[wikilinks]], not a codebase.',
    'Find notes with search_notes and backlinks before reading files one by one; read and edit notes with the file tools.',
    'Keep the author\'s wording, frontmatter, [[links]] and ![[embeds]] intact. Do not rename or move notes unless asked.',
    'When the user would understand something better by looking, open a pane: the graph to show how notes connect, a note to show it rendered.',
  ].join('\n'),
  // The vault extension (vault.ts, ui/vault.tsx) describes its panes to the agent itself (shared.ts).
  extensions: ['./vault.ts'],
  ui: ['./ui/vault.tsx'],
})
