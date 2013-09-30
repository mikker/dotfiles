source ~/.zsh/checks.zsh
source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# if rbenv is present, configure it for use
if which rbenv &> /dev/null; then
  # Put the rbenv entry at the front of the line
  export RBENV_ROOT=/usr/local/var/rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"

  # enable shims and auto-completion
  eval "$(rbenv init -)"
fi

# Local modifications
[[ -f ~/.local.rc ]] && .  ~/.local.rc
