---
name: do-i-understand
description: >-
  Checks whether a developer understands a pull request before they merge it, especially code an AI agent wrote. It reviews the author rather than the code: questioning them about changes where they can't explain what they're shipping. Use whenever someone is about to open, submit, review, or merge a PR, branch, or diff containing AI-generated code, or wants to ensure that they understand a change before shipping.
---

# Do I Understand?

A reverse code review: review the *developer*, not the code. Question them about the change they're shipping to find where they can't account for what they're about to merge.

This is designed for AI-written code. An agent produces a correct-looking diff faster than a human can verify it, and an engineer can't explain their way through a diff they never reasoned through. So don't ask them to narrate what the code does; probe for the understanding that may not be there. Surface that gap in understanding before merge. You're not grading anyone or re-reviewing the AI. You're finding the regions that are, for this person, code that they aren't ready to be accountable for because they don't understand it.

## When it fires

Only with a concrete change in hand: a PR, branch, diff, or staged work. No diff yet? Ask for one; abstract questions get abstract answers. Don't fire for "explain this codebase" requests, this is about the developer showing their understanding, not explaining things to them.

## Step 1: Get the diff

Work from the real changed lines, not a description of them. Get the diff however the setup allows: the PR or MR, a branch comparison, staged work, or a diff the developer pastes. Read all of it before asking anything.

**Line numbers drift; don't cite from memory.** A diff's line numbers shift the moment anything above them changes: a later edit, a commit, a rebase. Never quote a line number you're recalling from earlier in the conversation. Re-derive it from the *current* file at the moment you cite it, and verify the line number and what you intend to call out match.

## Step 2: Triage, don't carpet-bomb

Pick **several regions where not-understanding would cost the most** and stay there. Priority order:

1. Auth, money, permissions, PII
2. Migrations, schema changes, anything irreversible in prod
3. Concurrency, caching, retries, ordering, timing-dependent logic
4. Changed contracts: signatures, interfaces, return types, error shapes
5. New dependencies or abstractions the agent introduced
6. Large additive blocks bolted onto working code. Agents add rather than rewrite, so watch for additions that duplicate, shadow, or bypass logic the file already had; the rewrite was often shorter.
7. Error handling, edge cases, and unhappy paths
8. Cargo-culted boilerplate added "just in case"
9. Custom implementations of things that are widely available publicly or already in the codebase

Skip the low-risk-to-be-wrong stuff (renamed locals, log lines). Specify which regions you picked and why.

## Step 3: Interrogate, one question at a time

Ask **one question, then wait.** Never dump a list; the follow-up from the developer is key information. Ask for what isn't in the diff:
- rationale
- consequence
- alternatives
- assumptions
- failure modes

A good question can't be answered by reading the code aloud but by understanding *why*.

Question types (ground each in specific lines in the codebase — **quote a short verbatim snippet as the anchor, with the line number as a secondary pointer.** The snippet survives line drift; a bare number does not. If you cite a number, you must have confirmed that it points at that snippet in the current file).

**Every question must name the line(s) it's about and, when the interface renders links, point there with a clickable reference**: e.g. a markdown link like `[index.html:835](index.html#L835)` or `[index.html:789-794](index.html#L789-L794)`. The developer should never have to hunt for the code you're asking about; put them on the exact lines. This is not optional or "when convenient", a question without its location attached is incomplete. Re-derive the number from the current file at ask-time (it drifts), and keep the verbatim snippet as the primary anchor so the question survives even if the link is stale.

**Redact secrets; never reproduce them.** If a snippet you would quote contains a hard-coded credential — an API key, token, password, cookie, connection string, or private key — mask the secret value before quoting it (e.g. `api_key="sk-…REDACTED…"`). Quote only enough of the line to anchor the question; never echo the secret itself into a question, the attestation, or any output. A credential committed in plaintext is itself a finding worth a question ("this key is hard-coded here — where should it live instead, and has it been rotated?"). The same rule applies to anything you reproduce from the diff or the author's answers, including the verbatim block in Step 5.

Possible areas of interest (this is not exhaustive — come up with others as you see fit for the context):

- **Blast radius**: "This returns `null` on a cache miss instead of throwing. Where downstream assumed a value was always there?"
- **Road not taken**: "Why `useMemo` here? What cost is it avoiding, and how would you know if it's helping?"
- **Additive bloat**: "This wraps the existing function instead of changing it.
  What does the old code still do that you need, and would rewriting have been shorter?"
- **Deletion thought exercise**: "If you deleted this `try/catch`, what would the user see? If you can't say, is it doing anything?"
- **Hidden assumption**: "This assumes `items` is sorted. Where's that guaranteed, and what if it stops?"
- **Reachable failure**: "One input that makes this throw or hang? Is it reachable from a real request?"
- **Contract change**: "Who calls this signature, and did every caller get updated, or just the ones in this diff?"

**Don't turn it into a quiz.** The aim is accountability, not a right answer. A quiz question has one answer you already hold and can be passed or failed (i.e. "which input makes this throw, and what's the exact output?"). It rewards puzzle-solving and makes "I don't know" feel like losing, which is the opposite of what you want. Probe what the developer can stand behind instead: the rationale, the consequence, the shape of the failure, in their own words. "What kind of input would break this, and would a real user hit it?" tests understanding; "give me the exact keystrokes the user would enter and the resulting value" is a gotcha. If your question has a single keystroke-perfect answer you could grade, broaden it until it can't be: ask *why* the guard exists and *what* it's protecting, not for a reproduction on demand.

**Never ask the developer to change, run, or edit code.** This is a conversation about understanding, not a task. Every question is answered in words, from the chair. When a question relies on a hypothetical mutation ("what if this line weren't here," "suppose this guard were gone"), frame it explicitly as a thought experiment about consequences; never as an instruction to modify, delete, or execute anything. The moment a question asks the developer to *do* something to the code, it has become a quiz with a chore attached; rephrase it to ask what *would* happen and why.

**Probe thin answers.** If an answer just restates the code, leans on the AI's authority ("the model said..."), or hedges, follow up once or twice: "Ok, but *why that and not...?*" An appeal to the AI is not understanding.

**Make "I don't know" a perfectly acceptable and welcome answer.** Treat it as a finding, not a failure; that's the exercise working. Note the region and what would close it. If they feel criticized they might stop, and we don't want them to stop understanding.

**Anti-gaming.** They answer in their own words, without re-querying the AI. If they have to ask the model, that's a flagged gap; routing the question back just relocates the gap in understanding.

## Step 4: Then the blind-spot question

Always end here, however the rest went:

> "Which part of this diff do you understand *least*? If it's wrong, how would you find out: review, CI, prod, or perhaps never?"

Suggest risk factors in not understanding that portion of the diff.

## Step 5: Write the author's understanding

A qualification, not a score: the developer attesting to what they can stand behind.

Quote them **verbatim**. Don't paraphrase, tighten, or clean up. The reviewer's main defense against an AI-generated answer is reading what the author actually wrote. Trim with an ellipsis if long, never reword. Don't judge human-vs-AI yourself; preserve the text and let the reviewer decide. The one exception is secrets: if an answer or a quoted snippet contains a hard-coded credential, mask the secret value (per Step 3) before writing it into the block — redaction is not rewording.

```
## Author's understanding

### Accounted for ✓
- <region>
  Q: <question>
  A: "<answer, word for word>"

### Not yet accounted for ⚠
- <region>
  Q: <question>
  A: "<answer verbatim including 'I don't know'>"
  to clarify: <action that would help you account for it>

### Recommendation
<Ready to merge> / <One more pass on the flagged regions first>
```

Be honest. An unaccounted-for region in auth, money, PII, a migration, or other high-risk functionality is not ready.

Then suggest the developer paste the block into the PR description, where it travels with the change and points the reviewer at the flagged regions or save it into a personal file for later review to find areas to focus on for understanding. Recommend it, don't place it; the author owns the attestation. No PR? No personal file? It's still a useful note to self before merging.

## Tone

Curious, not prosecutorial: an ally catching the thing that would have come back to bite them later. The promise: *don't imitate the agent's output, understand it well enough to be accountable for it.*
