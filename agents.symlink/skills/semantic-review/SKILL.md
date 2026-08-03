---
name: semantic-review
description: Opens a semantic, narrative browser review of a git diff and returns the human reviewer's comments. Use after completing a substantial code change, or when the user asks for semantic-review, a narrative review, or a review of current changes.
license: MIT
compatibility: Requires Node.js 20+. Optional sidecars use ANTHROPIC_API_KEY or an installed claude, codex, gemini, or pi CLI.
disable-model-invocation: true
context: fork
background: false
agent: general-purpose
---

# Semantic Review

Run the review from the repository root after implementation and validation are complete. Interpret arguments supplied with the skill as natural-language preferences for how the analysis is generated.

## Isolated analysis (default)

When the user gives no harness or model preference, keep analysis out of the main conversation and give the analyzer no implementation history:

1. If this skill is already running in a forked or subagent context, generate the analysis there using the caller-provided workflow below.
2. Otherwise, prefer a fresh non-interactive invocation of the current harness via `--with claude`, `--with codex`, `--with gemini`, or `--with pi`. Do not pass conversation history. Skip the caller-provided workflow because the CLI handles analysis directly.
3. If the current harness has no CLI backend, use a native isolated subagent to generate the JSON from the emitted prompt.
4. Only generate analysis in the main hosting context when isolation is unavailable.

### Caller-provided analysis workflow

1. Create temporary prompt and JSON files outside the repository.
2. Run `npx --yes semantic-review --emit-prompt [git diff args...] > <prompt-file>`.
3. Read the entire prompt file and follow it yourself. Write only the requested JSON object to the JSON file, without Markdown fences or commentary.
4. Do not change the worktree between generating the prompt and opening the report.
5. Run `npx --yes semantic-review --analysis <json-file> [the same git diff args...]` in the foreground with a long timeout.
6. Delete both temporary files when the command exits.

With no git diff arguments, both commands review staged, unstaged, and untracked changes against `HEAD`. To review a branch, pass the same range such as `main...HEAD` to both commands. Custom ranges and piped diffs are reviewed exactly as supplied, so ensure they explicitly include any added files that are still untracked.

## Sidecar analysis

When the user expresses a harness or model preference in any wording, translate it into an independent sidecar invocation. Pass model IDs through verbatim; effort must be one of `low`, `medium`, `high`, `xhigh`, or `max`. If the intended harness or model is genuinely ambiguous, confirm the choice with the user instead of requiring special syntax or silently guessing.

```sh
npx --yes semantic-review --with anthropic --model claude-sonnet-5 --effort medium
npx --yes semantic-review --with claude --model sonnet
npx --yes semantic-review --with codex --model gpt-5.3-codex-spark
npx --yes semantic-review --with gemini --model gemini-2.5-pro
npx --yes semantic-review --with pi --model google/gemini-2.5-pro
```

For example, “use Claude Code with fable” means `--with claude --model fable`. The available harnesses are `anthropic`, `claude`, `codex`, `gemini`, and `pi`. CLI harnesses reuse their existing local authentication; `anthropic` uses `ANTHROPIC_API_KEY` or `ANTHROPIC_AUTH_TOKEN`. If the user names a harness without a model, leave off `--model` and let that backend choose its default.

To compare harnesses, provide a comma-separated list. Do not add `--model`, because model IDs are backend-specific:

```sh
npx --yes semantic-review --with anthropic,codex
```

## Workflow

1. Run the final review command in the foreground with a long timeout. Never background it.
2. Wait while the browser report is open. The command exits after the reviewer clicks **Done**.
3. Read stdout. Status messages and the review URL on stderr are not feedback.
4. If stdout says the review was approved with no comments, finish.
5. Otherwise, treat every comment as a change request. Make the requested changes, validate them, and summarize what changed.
6. If feedback is unclear, contradictory, or unsafe, ask the user before proceeding.

Do not use semantic review as a substitute for tests, type checks, or ordinary code inspection.
