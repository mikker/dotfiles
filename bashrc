# Path
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=/Users/mikker/bin:$PATH

# Git prompt
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\[\1$(parse_git_dirty)]/"
}

# Prompt
PS1='${SSH_CONNECTION}\[\e[0;33m\]$(parse_git_branch)\[\e[m\]\[\e[0;34m\]:\[\e[m\] ' # branch

# Shortcuts
o(){
  if [[ $1 ]]; then
    open "$1"
  else
    open .
  fi
}
m(){
  if [[ $1 ]]; then
    mate "$1"
  else
    mate .
  fi
}

# History
# see http://blog.macromates.com/2008/working-with-history-in-bash/
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend cdspell
bind Space:magic-space
alias h="history"
alias h?="history | grep"

# Completion
complete -C ~/dotfiles/rake-completion.rb -o default rake
source ~/dotfiles/git-completion.bash

# Aliases
source ~/dotfiles/aliases