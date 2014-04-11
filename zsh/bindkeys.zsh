bindkey "\e[3~" delete-char

# up-down searches history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# use incremental search
bindkey "^R" history-incremental-search-backward

# edit current command in $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

