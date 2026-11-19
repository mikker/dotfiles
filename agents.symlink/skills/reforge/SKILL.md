---
name: reforge
description: Work in a project hosted on Reforge (nexthub.sh), the GitHub Next forge, with the `reforge` CLI. Use when a repository's remote points at a Reforge host, when asked to move or set up a project on Reforge, or when about to reach for `gh` in a Reforge project. Covers setup and migration, the gh-to-reforge translation, and how to leave a useful record (Issues, Tasks, Reports, Goals) while building and shipping, without adding ceremony.
---

# Reforge

Reforge is a forge in GitHub's shape, built for agents. It has the same Git, the same
`.github/workflows`, and a CLI that mirrors `gh`. It also has more precise nouns for
work: Issues are problems, Tasks are decided work, Goals are outcomes, Decisions change
Goals, and Reports record findings. You know GitHub by heart. Use that knowledge, but
don't assume every GitHub habit carries over.

**The stance: ship first, record as you go.** Don't add ceremony upfront. Push and merge
the way the project allows. Then leave a short, typed record of what landed and why,
using the noun that fits. When no noun fits, leave no record. Every record should be
something a person or another agent will read later.

## Is this a Reforge project?

- `git remote -v` shows `nexthub.sh` (or another host that answers
  `https://<host>/.well-known/reforge`).
- Use `reforge`, not `gh`, for everything outside plain Git. `gh` talks to GitHub and
  will act on the wrong place or fail.
- The project's `AGENTS.md` overrides anything below.

## Setup and migration

```sh
curl -fsSL https://nexthub.sh/install | sh
reforge auth login && reforge auth setup-git     # git push/fetch use the same token
reforge import github OWNER/REPO                 # code + Issues, PRs, milestones, releases, Discussions
# or, code only:
git remote set-url origin https://nexthub.sh/OWNER/REPO && git push -u origin --all && git push origin --tags
```

The import keeps GitHub numbers. PRs become Changes, and milestones become Goals.
Workflows in `.github/workflows` run as they are: `GITHUB_TOKEN` and job `permissions:`
keep their GitHub names. Wikis, GitHub Projects, Actions history, secrets and settings
don't come over. Set secrets again with `reforge secret set`.

## gh → reforge

| gh                                            | reforge                                                              |
| --------------------------------------------- | -------------------------------------------------------------------- |
| `gh repo …`                                   | `reforge project …` (alias `repo`)                                   |
| `gh pr …`                                     | `reforge change …` (alias `pr`). A PR is a **Change**.               |
| `gh issue …`                                  | `reforge issue …`, but only for problems (see below)                 |
| issue used as a to-do                         | `reforge task …`                                                     |
| milestone                                     | Goal (`reforge goal …`) or a planned Release                         |
| `gh release …`                                | `reforge release …`                                                  |
| `gh run` / `gh workflow`                      | `reforge run` / `reforge workflow`                                   |
| `gh api`                                      | `reforge api` (same `{owner}/{repo}` placeholders)                   |
| `gh issue view N` / `gh pr view N`            | `reforge view N` resolves any number (Issues, Tasks, Discussions and Changes share one sequence) |

Add `--dry-run` to any command to see the requests it would make. Use it before any write
you're unsure of.

## Shipping

1. **Use the lightest path the project allows.** If you may push to the default branch,
   push. Open a Change only when the project or the person asks for review, or when your
   push is refused.
2. **If a write answers `428 ask_required`,** you're running as an agent whose owner wants
   to approve that action. Run `reforge agent ask …` with the escalation it printed, a
   plain question, your reason and the plan. Then stop and wait. Don't look for another
   route to make the same write.
3. **Write commit messages that tell the story.** On a trunk-based project, the commit log
   is the review surface and the timeline people read.

## Keep the record

After something lands, ask: *will anyone need to find this later as more than a commit?*
Usually the answer is no. Write a record only when it is yes:

| Write                                | When                                                                                                    | Not when                                                                                     | How                                                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Issue**                            | You found a defect, regression or risk that you're *not* fixing now                                      | You're about to fix it: fix it, and mention it in the commit                                 | `reforge issue create -t … -b … [-p high]`                                                                             |
| **Task**                             | Decided work that outlives this session: a follow-up, a split for subagents, something blocked           | Work you're doing right now                                                                  | `reforge task create -t … [--addresses ISSUE] [--parent TASK] [--blocked-by TASK]`; finish with `reforge task close N` |
| **Link a Change**                    | You opened a Change for a Task or Issue                                                                 | —                                                                                            | `reforge change create --implements TASK --addresses ISSUE`                                                            |
| **Report**                           | Findings worth keeping: an audit, a benchmark, a test or investigation result, an incident write-up     | A recap of what you just did; the commit or thread already says it                           | `reforge api -X POST '/repos/{owner}/{repo}/reports' -f title=… -f 'content[format]=markdown' -f 'content[text]=…' -F 'about[]=N'` |
| **File work under a Goal**           | The work clearly serves a Goal that already exists                                                      | You'd have to guess                                                                          | `reforge goal add GOAL N…`                                                                                             |
| **Proposal**                         | You think a Goal, or the roadmap, should change                                                         | Ever recording the Decision yourself                                                         | `reforge discussion create -k proposal -t … --motivation … --proposed-change …`                                        |
| **Release**                          | The person asks to cut one                                                                              | Every merge                                                                                  | `reforge release create TAG -n …` (`--draft` keeps it planned)                                                         |

Rules:

- **Goals and Decisions belong to people.** Agents can't record Decisions, and you
  shouldn't create Goals on your own initiative. Propose them instead.
- **Close the loop on what you touch.** When work lands, close the Task (`done`) or the
  Issue (`completed`) with a one-line comment that names the commit or Change.
- **Search before you write.** Use `reforge issue list`, `reforge task list` and
  `reforge goal list`. Link or comment instead of opening a duplicate.
- **Keep records short.** A title that says what it is, and a body with evidence and
  links. Each record keeps a version history, so be precise rather than complete.
- **No Plan documents as a habit.** Write a Plan only when a person asks for a written
  approach to a set of Tasks.

## Threads and agents

- `reforge thread new --harness claude "…"` (or `--agent OWNER/SLUG`) starts a hosted
  agent session tagged with the current repository. `reforge thread list`, `view` and
  `follow` show sessions.
- Agents are defined in `<owner>/.agents/<slug>.yml`, with `grants`, `escalate` and a
  budget. Writes to `.agents` always ask first.
- Everything an agent writes is attributed to it and to the person it acts for. You don't
  need to sign your records.
