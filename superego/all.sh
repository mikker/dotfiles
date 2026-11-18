#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

command_exists superego || { echo "Superego is required to install profiles" >&2; exit 1; }

# Superego's user profiles: github.com/mikker/superego-profiles, from the local checkout when there is one.
local_profiles="$HOME/dev/superego-profiles"
if [ -d "$local_profiles" ]; then
  superego profile install "$local_profiles"
else
  superego profile install git:github.com/mikker/superego-profiles
fi

# Links from before profile sources, which would shadow the source's profiles.
for link in "$HOME"/.superego/profiles/*; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in
    "$local_profiles"/profiles/* | "$HOME"/.dotfiles/superego/profiles/*) rm "$link" ;;
  esac
done

superego profile types --user || echo "superego profile types --user failed: run it again once Superego is set up" >&2
