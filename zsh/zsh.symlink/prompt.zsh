autoload -Uz vcs_info

local mark='.'

zstyle ':vcs_info:*' stagedstr "%F{28}$mark"
zstyle ':vcs_info:*' unstagedstr "%F{11}$mark"
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
    zstyle ':vcs_info:*' formats " [%F{green}%b%c%u%F{red}$mark%F{blue}]"
  }

  vcs_info
}

PROMPT='$(parse_ssh_connection)%c %(1j.%F{magenta}[%j]%f.)%F{blue}$%f '
RPROMPT='%F{blue}${vcs_info_msg_0_}%f'

