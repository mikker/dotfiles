// Stand-ins for the bundled extensions staff leans on, which a test daemon hasn't: as little of each as staff uses.
import { randomUUID } from 'node:crypto'
import { arr, defineAction, defineDaemonExtension, defineExtension, defineTool, obj, opt, str } from 'superego'

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

type Waiting = { id: string; thread: string; at: number; tool: 'ask_user'; question: string; options: { label: string }[] }

/** agent-ui: ask_user waits on an answer, published as what the thread waits on (`agent-ui.waiting`); `agent-ui.answer` gives it. */
export const agentUi = defineDaemonExtension({
  name: 'agent-ui',
  setup(superego) {
    const waiting = superego.scopedValue<Waiting[]>('agent-ui.waiting', [])
    const answers = new Map<string, (text: string) => void>()
    superego.action(defineAction({
      id: 'agent-ui.answer', title: 'Answer what the agent is waiting on', params: obj({ id: str(), text: opt(str()) }),
      run({ id, text }) {
        const give = answers.get(id)
        if (!give) throw new Error('That question is no longer waiting')
        answers.delete(id)
        give(text ?? '')
        return null
      },
    }))
    superego.agent(defineExtension({
      name: 'agent-ui',
      tools: [defineTool({
        name: 'ask_user', description: 'Ask the user, and wait for the answer.',
        parameters: obj({ question: str(), options: opt(arr(str())) }),
        async execute({ question, options }, api) {
          const thread = superego.threads.of(api.conversationId)!
          const id = randomUUID()
          waiting.set(thread, [{ id, thread, at: Date.now(), tool: 'ask_user', question, options: (options ?? []).map((label) => ({ label })) }])
          const answer = await new Promise<string>((resolve) => answers.set(id, resolve))
          waiting.set(thread, [])
          return { output: [{ type: 'text', text: answer }] }
        },
      })],
    }))
  },
})
