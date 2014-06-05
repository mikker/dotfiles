fpath=( "$HOME/.zsh/functions" $fpath )

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

# Local modifications
[[ -f ~/.local.rc ]] && .  ~/.local.rc

