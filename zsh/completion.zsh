# completion
autoload -U compinit && compinit
zmodload -i zsh/complist

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

_ag() {
  if (( CURRENT == 2 )); then
    compadd $(cut -f 1 tags .git/tags tmp/tags 2>/dev/null | grep -v '!_TAG')
  fi
}

compdef _ag ag

