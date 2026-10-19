#!/usr/bin/env bash
set -euo pipefail

gnupg_home="${GNUPGHOME:-$HOME/.gnupg}"
agent_config="$gnupg_home/gpg-agent.conf"
pinentry_program="$(brew --prefix)/bin/pinentry-mac"

mkdir -p "$gnupg_home"
chmod 700 "$gnupg_home"
touch "$agent_config"

# Preserve other agent settings and replace any existing pinentry selection.
config="$(awk '!/^[[:space:]]*pinentry-program([[:space:]]|$)/' "$agent_config")"
{
  if [[ -n "$config" ]]; then
    printf '%s\n' "$config"
  fi
  printf 'pinentry-program %s\n' "$pinentry_program"
} > "$agent_config"
chmod 600 "$agent_config"

gpgconf --reload gpg-agent
