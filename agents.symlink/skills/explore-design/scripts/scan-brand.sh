#!/usr/bin/env bash
# Brand scan + init gate for the explore-design skill.
# One pass that reports: whether a repo-local branded template exists (the init
# gate), candidate design-system docs, theme/token files, and font signals.
# Usage: scan-brand.sh [repo-root]   (defaults to current directory)
set -u
ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "ERROR: cannot cd to $ROOT"; exit 1; }

PRUNE=( -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" -not -path "*/.next/*" -not -path "*/build/*" -not -path "*/vendor/*" )
# exploration outputs and this skill's own assets must not feed the scan
EXG="--exclude-dir=design-explorations --exclude-dir=explorations --exclude-dir=.explorations --exclude-dir=explore-designs"

TPL=$(find . -maxdepth 5 -name "_template.html" \( -path "*exploration*" -o -path "*scratch*" \) "${PRUNE[@]}" 2>/dev/null | head -1)
BRAND=$(find . -maxdepth 5 -name "_brand.md" "${PRUNE[@]}" 2>/dev/null | head -1)

echo "== INIT GATE =="
if [ -n "$TPL" ]; then
  echo "STATUS: TEMPLATE_FOUND"
  echo "TEMPLATE: $TPL"
  [ -n "$BRAND" ] && echo "BRAND_NOTES: $BRAND"
  echo "ACTION: copy this template for the new exploration. Do NOT re-run brand init unless the user asked to re-init/rebrand."
else
  echo "STATUS: NO_TEMPLATE"
  echo "ACTION: brand init is REQUIRED before writing any exploration HTML."
  echo "        Read references/brand-init.md in the skill directory and follow it."
  echo "        (Init styles the document chrome only — the source mock/wireframe is content, not a brand input.)"
fi

echo
echo "== DESIGN-SYSTEM DOCS =="
find . -maxdepth 5 \( -iname "DESIGN.md" -o -iname "design-system*" -o -iname "*style-guide*" -o -iname "brand.md" -o -iname "brand-guide*" \) "${PRUNE[@]}" 2>/dev/null | head -10
find . -maxdepth 5 -type d -iname "tokens" "${PRUNE[@]}" 2>/dev/null | head -5

echo
echo "== THEME / TOKEN FILES =="
find . -maxdepth 3 -name "tailwind.config.*" "${PRUNE[@]}" 2>/dev/null | head -5
CSS_WITH_ROOT=$(find . -maxdepth 5 -name "*.css" "${PRUNE[@]}" -not -path "*exploration*" -not -path "*explore-designs*" 2>/dev/null | head -60 | xargs grep -l ":root" 2>/dev/null | head -5)
if [ -n "$CSS_WITH_ROOT" ]; then
  echo "-- CSS files with :root custom properties --"
  echo "$CSS_WITH_ROOT"
  echo "-- sample custom properties --"
  echo "$CSS_WITH_ROOT" | xargs grep -h -- "--[A-Za-z][A-Za-z0-9-]*:" 2>/dev/null | sed 's/^[[:space:]]*//' | head -30
fi

echo
echo "== FONTS =="
grep -rhoE "fonts\.googleapis\.com/css2\?[^\"' ]+" --include="*.html" --include="*.css" --include="*.vue" --include="*.tsx" --include="*.ts" --include="*.js" --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist $EXG . 2>/dev/null | head -5
grep -rhoE "font-family:[^;}]+" --include="*.css" --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist $EXG . 2>/dev/null | sed 's/^[[:space:]]*//' | sort -u | head -10

echo
echo "== DONE =="
