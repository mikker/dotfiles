// Dotfiles-managed Pi extension.

/**
 * Find the sequence of `pattern` lines within `lines` beginning at or after
 * `start`. Returns the starting index, or undefined if not found.
 *
 * Matches are attempted with decreasing strictness:
 *   1. exact
 *   2. ignore trailing whitespace (rstrip)
 *   3. ignore leading and trailing whitespace (trim)
 *   4. normalize common Unicode punctuation to ASCII equivalents
 *
 * When `eof` is true, the search starts at the end of the file so patterns
 * intended to match file endings land there, falling back to searching from
 * `start`.
 *
 * Ported from openai/codex `codex-rs/apply-patch/src/seek_sequence.rs`.
 */
export function seekSequence(
  lines: string[],
  pattern: string[],
  start: number,
  eof: boolean,
): number | undefined {
  if (pattern.length === 0) return start;
  if (pattern.length > lines.length) return undefined;

  const searchStart =
    eof && lines.length >= pattern.length
      ? lines.length - pattern.length
      : start;
  const upper = lines.length - pattern.length; // inclusive upper bound for i

  // 1. exact
  for (let i = searchStart; i <= upper; i++) {
    if (exactMatch(lines, pattern, i)) return i;
  }
  // 2. rstrip
  for (let i = searchStart; i <= upper; i++) {
    if (rstripMatch(lines, pattern, i)) return i;
  }
  // 3. trim both sides
  for (let i = searchStart; i <= upper; i++) {
    if (trimMatch(lines, pattern, i)) return i;
  }
  // 4. unicode-normalized
  for (let i = searchStart; i <= upper; i++) {
    if (normalizeMatch(lines, pattern, i)) return i;
  }

  return undefined;
}

function exactMatch(lines: string[], pattern: string[], i: number): boolean {
  for (let p = 0; p < pattern.length; p++) {
    if (lines[i + p] !== pattern[p]) return false;
  }
  return true;
}

function rstripMatch(lines: string[], pattern: string[], i: number): boolean {
  for (let p = 0; p < pattern.length; p++) {
    if (rstrip(lines[i + p] ?? "") !== rstrip(pattern[p] ?? "")) return false;
  }
  return true;
}

function trimMatch(lines: string[], pattern: string[], i: number): boolean {
  for (let p = 0; p < pattern.length; p++) {
    if ((lines[i + p] ?? "").trim() !== (pattern[p] ?? "").trim()) return false;
  }
  return true;
}

function normalizeMatch(
  lines: string[],
  pattern: string[],
  i: number,
): boolean {
  for (let p = 0; p < pattern.length; p++) {
    if (normalize(lines[i + p] ?? "") !== normalize(pattern[p] ?? ""))
      return false;
  }
  return true;
}

function rstrip(s: string): string {
  return s.replace(/\s+$/u, "");
}

/** Normalize common typographic Unicode punctuation to ASCII equivalents. */
export function normalize(s: string): string {
  return Array.from(s.trim())
    .map((c) => {
      switch (c) {
        // Various dash / hyphen code-points -> ASCII '-'
        case "\u2010":
        case "\u2011":
        case "\u2012":
        case "\u2013":
        case "\u2014":
        case "\u2015":
        case "\u2212":
          return "-";
        // Fancy single quotes -> '\''
        case "\u2018":
        case "\u2019":
        case "\u201A":
        case "\u201B":
          return "'";
        // Fancy double quotes -> '"'
        case "\u201C":
        case "\u201D":
        case "\u201E":
        case "\u201F":
          return '"';
        // Non-breaking and odd spaces -> normal space
        case "\u00A0":
        case "\u2002":
        case "\u2003":
        case "\u2004":
        case "\u2005":
        case "\u2006":
        case "\u2007":
        case "\u2008":
        case "\u2009":
        case "\u200A":
        case "\u202F":
        case "\u205F":
        case "\u3000":
          return " ";
        default:
          return c;
      }
    })
    .join("");
}
