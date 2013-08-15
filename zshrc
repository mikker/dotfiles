# Path
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
export PATH="$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# completion
autoload -U compinit
compinit

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

# up-down searches history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# automatically enter directories without cd
setopt auto_cd

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# use incremental search
bindkey "^R" history-incremental-search-backward

# save history to a file
HISTFILE=$HOME/.zsh_history

# ignore duplicate history entries
setopt histignoredups

# keep TONS of history
export HISTSIZE=4096

# source some more sauce
[[ -f ~/.zsh/prompt ]] && . ~/.zsh/prompt
[[ -f ~/.zsh/functions ]] && . ~/.zsh/functions
[[ -f ~/.zsh/aliases ]] && . ~/.zsh/aliases

# Local modifications
[[ -f ~/.local.rc ]] && .  ~/.local.rc
