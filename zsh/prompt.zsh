# echo a * if git status is dirty
parse_git_dirty() {
  [[ ! $(git status) =~ 'nothing to commit' ]] && echo "*"
}

parse_git_branch() {
  (command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

parse_ssh_connection() {
  [[ -n $SSH_CONNECTION ]] && echo "%m "
}

git_info_for_prompt() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "%{$fg[yellow]%}[${git_where#(refs/heads/|tags/)}$(parse_git_dirty)]%{$reset_color%}"
}

local char="$"
PROMPT="$(parse_ssh_connection)%(1j.%{$fg[magenta]%}[%j]%{$reset_color%}.)%{$fg[red]%}${char}%{$reset_color%} "
RPROMPT="%{$fg[cyan]%}%~%{$reset_color%}$(git_info_for_prompt)"

