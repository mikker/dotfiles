# General
alias so='source'
alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias ddate='date +"%Y-%m-%d"'
alias ytdl='cd ~/Movies && youtube-dl `pbpaste`'
alias doco='docker-compose'
alias mux='tmuxinator'
alias rm_orig="find . -name '*.orig' -exec rm {} \;"
alias json='python -mjson.tool'
alias pweb='python -m SimpleHTTPServer'
alias online='ping -c 1 google.com &> /dev/null'
alias dsay='say -v Sara'
alias doc='docker-compose'
alias ruby-vers="cat Gemfile | grep '^ruby' | sed -E \"s/.*[\\\"'](.+)[\\\"']/\1/"\"
alias docker-killall="docker ps | tail -n +2 | awk '{ print \$1 }' | xargs docker kill"

# tmux
alias tm="tmux -u"
alias ta='tmux attach'
alias tat='tmux new-session -As `basename $PWD | sed -e "s/\./-/g"`'
alias tk='tmux kill-session'
alias tkall='while true; do tk || break; done'
alias tmux-set-title='tmux rename-session `basename $PWD | sed -e "s/\./-/g"`'

# Git
alias g='git'
alias gp='git push'
alias ga='git add --all'
alias gd='git diff'
alias gl='git log'
alias gla='git log --all'
alias gt='git tree'
alias gta='git tree --all'
alias gdt='git difftool'
alias gmt='git mergetool'
alias gs='git status -sb'
alias gci='git commit -m'
alias gcm='git checkout master'
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
# Hub
alias gb='hub browse'
alias gpr='hub pull-request'

# Ruby
alias be='bundle exec'
alias ra='rails'

# JS
alias yr="yarn run"
alias npr="npm run"
alias hh="yarn hardhat"


# https://twitter.com/almonk/status/1576294814831718400
alias todo='git grep -l TODO | xargs -n1 git blame -f -n -w | grep "$(git config user.name)" | grep TODO | sed "s/.\{9\}//" | sed "s/(.*)[[:space:]]*//"'

