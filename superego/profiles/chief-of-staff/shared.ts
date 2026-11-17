// What staff is, for both halves (spread into each), and what they share: the board's value and its shapes.
export const about = {
  name: 'staff', api: '^3', title: 'Chief of staff',
  panes: {
    'staff-board': "the user's overview of this thread's work: the programme's waves (board_plan), what needs the user " +
      "(decisions from board_ask, children's questions, stalls), each child's progress and changes, queued starts, and " +
      'what landed; no params',
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

/** An answer offered to a decision, with a line about it where the label needs one. */
export type Option = { label: string; description?: string }

/**
 * A decision the lead put on the board (board_ask) for the user: the question, its options, the threads it's about (ids
 * or titles), and its answer once given: by the user on the board, or by the lead closing it (board_close).
 */
export type Decision = {
  id: string; question: string; options: Option[]; about: string[]; at: number
  answer?: { text: string; at: number; by: 'user' | 'lead' }
}

/**
 * The programme as the lead lays it out (board_plan): a title, a line on where it stands, its waves of lanes. A lane is a
 * thread's id, a queued start's (until it starts, when it becomes its thread's), or a title for one not started yet.
 */
export type Plan = { title?: string; summary?: string; waves: { title: string; lanes: string[] }[]; at: number }

/**
 * One lead's board: its stalled children (since when, in which call), queued starts, each child's changes, its reports,
 * its plan and decisions.
 */
export type Board = {
  stalled: Record<string, { since: number; call?: string }>; queued: { id?: string; title: string; at: number }[]
  changes: Record<string, Changes>; reports: Report[]; plan?: Plan; decisions: Decision[]
}
export const EMPTY_BOARD: Board = { stalled: {}, queued: [], changes: {}, reports: [], decisions: [] }

/** What a child's agent waits on, as agent-ui publishes it in the child's scope: an ask_user's question, or an ask_ui's blocks. */
export type Waiting = { id: string; thread: string; at: number; tool: string; question?: string; options?: Option[]; title?: string }
/** agent-ui's: what each thread waits on (a scoped value), and the action that answers it. */
export const WAITING = 'agent-ui.waiting'
export const ANSWER = 'agent-ui.answer'

/** `staff.details`: each child's last answer in a line, and whether its branch is merged. */
export type Details = { id: string; answer: string | null; merged: boolean | null }
