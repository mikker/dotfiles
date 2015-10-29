autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{28}●'
zstyle ':vcs_info:*' unstagedstr '%F{11}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn

parse_ssh_connection() {
  [[ -n $SSH_CONNECTION ]] && echo "%n@%m "
}

precmd () {
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
    zstyle ':vcs_info:*' formats ' [%F{green}%b%c%u%F{blue}]'
  } else {
    zstyle ':vcs_info:*' formats ' [%F{green}%b%c%u%F{red}●%F{blue}]'
  }

  vcs_info
}

setopt prompt_subst

ti_status() {
  local ti=$(ti status 2> /dev/null | sed -E 's/.*on //' | sed -E 's/ for.*//' | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g')
  [[ $ti ]] && echo "%F{red}!$ti %f"
}

PROMPT='$(parse_ssh_connection)$(ti_status)%c %(1j.%F{magenta}[%j]%f.)%F{blue}$%f '
RPROMPT='%F{blue}${vcs_info_msg_0_}%f'

