// Stand-ins for the bundled extensions staff leans on, which a test daemon hasn't: as little of each as staff uses.
import { defineDaemonExtension, defineExtension, defineTool, obj, opt, str } from 'superego'

/** thread-tools' thread_start: a child of the calling thread, in its folder, started without its prompt (so a test's model script needn't make room for the child's turn). */
export const threadTools = defineDaemonExtension({
  name: 'thread-tools',
  setup(superego) {
    superego.agent(defineExtension({
      name: 'thread-tools',
      tools: [defineTool({
        name: 'thread_start', description: 'Start a child thread.', executionMode: 'sequential',
        parameters: obj({ prompt: str(), title: opt(str()) }),
        async execute({ title }, api) {
          const parent = superego.threads.of(api.conversationId)!
          const child = await superego.threads.start({ parent, cwd: (await superego.threads.get(parent)).cwd, ...(title ? { title } : {}) })
          return { output: [{ type: 'text', text: `Started ${child.title}` }] }
        },
      })],
    }))
  },
})

type Worktree = { path: string; branch: string }

/** worktrees: a thread asked for one (`options.worktrees`: its path and branch) works in it, and says so in its facts. */
export const worktrees = defineDaemonExtension({
  name: 'worktrees',
  setup(superego) {
    superego.facts(({ state }) => state)
    superego.thread<Worktree>({
      starting(draft) {
        const tree = draft.options.worktrees as Worktree | undefined
        return tree ? { cwd: tree.path, state: tree } : undefined
      },
    })
  },
})
