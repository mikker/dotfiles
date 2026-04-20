---
name: defuddle
description: Read web pages as markdown with `npx defuddle`. Use when the user wants a simple local URL-to-markdown fetcher instead of Jina or browser automation.
---

# Defuddle

Fetch a web page and turn it into readable markdown with `npx defuddle`.

## Usage

```bash
{baseDir}/defuddle.sh <url>
```

## Examples

```bash
# Read an article as markdown
{baseDir}/defuddle.sh https://example.com/article

# Save output yourself
{baseDir}/defuddle.sh https://example.com/article > article.md

# Get structured JSON directly from defuddle
npx -y defuddle parse --json https://example.com/article

# Extract one field
npx -y defuddle parse --property title https://example.com/article
```

## What it does

The wrapper runs:

```bash
npx -y defuddle parse --markdown <url>
```

It validates the URL first, then prints markdown to stdout.

## When to use

- Read articles, docs, blog posts, release notes
- Quickly fetch a site as markdown
- Prefer a local parser over hosted reader services

## Notes

- Requires network access
- Uses `npx`, so first run may be slower
- Best for mostly server-rendered pages; JS-heavy sites may still need browser automation
