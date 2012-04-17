local anchor="%(?,%{$fg[green]%}⚓%{$reset_color%},%{$fg[red]%}⚓%{$reset_color%})"
PROMPT='
${anchor} '
RPROMPT='$(git_prompt_info) %{$fg[cyan]%}%~%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
