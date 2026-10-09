# Telling an explainer reel

## Structure

- **Behavior before code.** For each change: the broken behavior first, the fixed
  behavior replayed in the same space, then the code diff. Viewers should
  understand what goes wrong before they see why.
- **Replay, don't redraw.** Actors shared by both stories stay; broken-only elements
  fade or rewind; the fix resolves the same moment differently. The switch is the
  comparison.
- **One idea per beat.** A packet, a callout, a strike, or a caption appears when
  the narration says it, and not before.

## Motion craft

Every reel is judged on motion craft; flat fades are the failure mode. Apply the
`explainer-motion` skill to every beat (its rules, beats, and constants are the
single source), and use the Stage's helpers that implement them.

## Narration

- Plain, confident, short sentences. Say what happens, then why it matters. No
  hype, no filler, no "basically".
- Spell things as they should be spoken; the transcript, not the script, decides
  what an anchor matches.
- When using ElevenLabs `eleven_v4`, place concise vocal directions in square
  brackets before the clause (`[warm, conversational voice]`, `[measured,
  concerned voice]`, `[firm, clear delivery]`) and verify that no direction tags
  were spoken in the generated `.words.json` transcript.
- **Anchors** are the phrases visuals wait for. Choose plain words the speech
  recognizer cannot reformat. Avoid acronyms and jargon (TUI, SIGKILL) and spoken
  punctuation as anchors; number words are fine because they match digits.
- Each anchor must be unique within its clip. If a phrase repeats, anchor on the
  earlier phrase and search after it.

## Visual voice

- Themes: `--theme neutral` or `--theme opencode`, CommitMono, lowercase captions,
  one accent keyword per caption, block caret while typing.
- Tones mean the same thing everywhere: request (blue), success (green), error
  (red), warning (yellow), muted, accent (the one thing to follow).
- Header caption top left (`#number  title`), status chip top right (`before`,
  `◀◀ rewind`, `after the fix`, `the change`), one footer caption that sums up the beat.
- Behavior stories use the Stage (orb, cards, beams, packets, callouts, rolling
  numbers); keep Sequence Diagrams for protocols with many ordered messages.
- Code is **condensed for display**, never invented: at most 76 columns and 14 rows,
  real identifiers, the same shape as the real change. Say so in the footer.
- Prefer `zoom` transitions when flying from a Stage card into its code, and `dip`
  transitions between text-dense segments.
