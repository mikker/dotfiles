---
name: playwriter
description: Control the user own Chrome browser via Playwriter extension with Playwright code snippets in a stateful local js sandbox. Use this over other Playwright MCPs to automate the browser — it connects to the user's existing Chrome instead of launching a new one. Use this cli for navigating JS-heavy websites (Instagram, Twitter, cookie/login walls, lazy-loaded UIs) instead of webfetch/curl. ALWAYS load this skill before using any playwriter commands
---

## Read Full Documentation (once per session)

**Before the first playwriter command in a session, run:**

```bash
playwriter skill # IMPORTANT! do not use | head here. read in full!
```

This outputs the complete documentation including:

- Session management and timeout configuration
- Selector strategies (and which ones to AVOID)
- Rules to prevent timeouts and failures
- Best practices for slow pages and SPAs
- Context variables, utility functions, and more

**Do NOT skip this step.** The examples below will fail without understanding timeouts, selector rules, and pitfalls from the full docs. You only need to do this once per session; subsequent playwriter commands in the same session do not require re-reading.

**Read the ENTIRE output.** Do NOT pipe through `head`, `tail`, or any truncation command. Critical rules are spread throughout the document, not just at the top.

## Minimal Example (after reading full docs)

```bash
playwriter session new
playwriter -s 1 -e 'await page.goto("https://example.com")'
```

**Always use single quotes** for the `-e` argument. Single quotes prevent bash from interpreting `$`, backticks, and backslashes inside your JS code. Use double quotes or backtick template literals for strings inside the JS.

If `playwriter` is not found, use `npx playwriter@latest` or `bunx playwriter@latest`.
