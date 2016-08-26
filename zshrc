export PATH="$HOME/bin:$HOME/.bin:/usr/local/bin:/usr/local/sbin:$PATH"
export VISUAL=vim
export EDITOR=$VISUAL

source ~/.zsh/base.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/aliases.zsh

# Load all functions in fn dir
local fns="$HOME/.zsh/functions"

fpath=( $fns $fpath )
for fn in $(ls $fns); do
  autoload -U $fn
done

c # preload c because apparently

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# Local modifications
[[ -f ~/.localrc ]] && .  ~/.localrc

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
