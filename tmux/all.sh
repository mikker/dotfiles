#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
  # TPM normally initializes this from a live tmux session. Bootstrap may run
  # before the user's first session, so keep a temporary server alive while it
  # discovers the configured plugin directory.
  bootstrap_session="dotfiles-bootstrap-$$"
  tmux new-session -d -s "$bootstrap_session"
  trap 'tmux kill-session -t "$bootstrap_session" 2>/dev/null || true' EXIT
  tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
  tmux kill-session -t "$bootstrap_session"
  trap - EXIT
else
  echo "Skipping tmux plugin install; TPM is missing"
fi

link_path "tmux/tmuxinator" "$HOME/.config/tmuxinator"
