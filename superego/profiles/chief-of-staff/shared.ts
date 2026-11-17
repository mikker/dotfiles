// What staff is, for both halves (spread into each), and what they share: the board's value and its shapes.
export const about = {
  name: 'staff', api: '^3', title: 'Chief of staff',
  panes: {
    'staff-board': "this thread's children at a glance: state, time since each last made progress, stalls, worktrees, " +
      'their changes and merges, queued starts, and reports kept until the user dismisses them; no params',
  },
}

/** What the board shows besides what the window knows of threads, scoped by lead: stalls, queued starts, changes, reports. */
export const BOARD = 'staff.board'
/** The board pane's kind. */
export const PANE = 'staff-board'

/** What a worktree's branch changed since it left main: its files, with lines added and removed (`more` files not listed). */
export type Changes = { files: { path: string; added: number; removed: number }[]; added: number; removed: number; more?: number }

/** A child's report-back as the board keeps it until dismissed: how it ended, what it said, what its branch changed. */
export type Report = {
  id: string; title: string; at: number; outcome: 'done' | 'error' | 'question'; answer: string
  branch?: string; changes?: Changes; merged?: boolean
}

/** One lead's board: its stalled children (since when, in which call), queued starts, each child's changes, its reports. */
export type Board = {
  stalled: Record<string, { since: number; call?: string }>; queued: { title: string; at: number }[]
  changes: Record<string, Changes>; reports: Report[]
}
export const EMPTY_BOARD: Board = { stalled: {}, queued: [], changes: {}, reports: [] }

/** `staff.details`: each child's last answer in a line, and whether its branch is merged. */
export type Details = { id: string; answer: string | null; merged: boolean | null }
