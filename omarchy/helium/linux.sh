#!/usr/bin/env bash
set -euo pipefail

preferences="$HOME/.config/net.imput.helium/Default/Preferences"

if [[ ! -f "$preferences" ]]; then
  echo "Skipping Helium shortcuts; launch Helium once, then rerun setup"
  exit 0
fi

if jq -e '
  ((.helium.browser.custom_accelerators["34017"].added // []) |
    index("Shift+Meta+BracketLeft") != null)
  and
  ((.helium.browser.custom_accelerators["34062"].added // []) |
    index("Shift+Meta+BracketRight") != null)
  and
  ((.helium.browser.custom_accelerators["35000"].removed // []) |
    index("Control+KeyD") != null)
  and
  ((.helium.browser.custom_accelerators["35002"].removed // []) |
    index("Control+KeyU") != null)
' "$preferences" >/dev/null; then
  echo "Helium shortcuts already configured"
  exit 0
fi

if pgrep -x helium >/dev/null; then
  echo "Skipping Helium shortcuts; quit Helium, then rerun setup"
  exit 0
fi

tmp="$(mktemp "${preferences}.tmp.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

# Helium 0.18 command IDs: previous tab (34017), next tab (34062), bookmark
# this tab (35000), and view source (35002).
jq '
  .helium.browser.custom_accelerators["34017"].added =
    (((.helium.browser.custom_accelerators["34017"].added // []) +
      ["Shift+Meta+BracketLeft"]) | unique) |
  .helium.browser.custom_accelerators["34062"].added =
    (((.helium.browser.custom_accelerators["34062"].added // []) +
      ["Shift+Meta+BracketRight"]) | unique) |
  .helium.browser.custom_accelerators["35000"].removed =
    (((.helium.browser.custom_accelerators["35000"].removed // []) +
      ["Control+KeyD"]) | unique) |
  .helium.browser.custom_accelerators["35002"].removed =
    (((.helium.browser.custom_accelerators["35002"].removed // []) +
      ["Control+KeyU"]) | unique)
' "$preferences" > "$tmp"

chmod --reference="$preferences" "$tmp"
mv "$tmp" "$preferences"
trap - EXIT

echo "Configured Helium shortcuts"
