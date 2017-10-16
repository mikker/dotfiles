# General
alias so='source'
alias l='ls'
alias ll='ls -lh'
alias la='ls -a'

# tmux
alias t="tmux -u"
alias ta='tmux attach'
alias tat='tmux new-session -As `basename $PWD | sed -e "s/\./-/g"`'
alias tk='tmux kill-session'
alias tkall='while true; do tk || break; done'
alias tmux-set-title='tmux rename-session `basename $PWD | sed -e "s/\./-/g"`'

# Git
alias g='git'
alias gp='git push'
alias gf='git fetch'
alias gu='git pull'
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
alias re='touch tmp/restart.txt'
alias be='bundle exec'
alias fs='shoreman' # https://github.com/chrismytton/shoreman
alias mm='middleman'
alias zs='zeus'
# Rails
alias rgen='rails generate'
alias rc='rails console'
alias rs='rails server'
alias rd='rails destroy'
alias migrate='rake db:migrate db:test:prepare'
alias remigrate='rake db:migrate:redo db:test:prepare'
alias tld='tail -F log/development.log'
alias tlp='tail -F log/production.log'
alias tlt='tail -F log/test.log'

alias json='python -mjson.tool'
alias pweb='python -m SimpleHTTPServer'

if [ is_mac ]; then
  alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
  alias mailsize="du -hs ~/Library/mail"
  alias md='open -a Marked'
  alias safari_address="osascript -e 'tell application \"Safari\" to return URL of current tab of front window'"
  alias temp="/Applications/TemperatureMonitor.app/Contents/MacOS/tempmonitor -c -l -a"
  alias batt="pmset -g batt | sed '1d' | sed -e 's/-InternalBattery-0//' | awk '{\$1=\$1}1'"
fi

alias wget-dump="wget -mpck --user-agent="" -e robots=off"
alias ddate='date +"%Y-%m-%d"'
alias ytdl='cd ~/Movies && youtube-dl `pbpaste`'
alias doco='docker-compose'
alias mux='tmuxinator'
alias rm_orig="find . -name '*.orig' -exec rm {} \;"
alias online='ping -c 1 google.com &> /dev/null'
alias dsay='say -v Sara'
alias gcb="git chechout -b"
alias exc="exercism"
alias yr="yarn run"
alias npr="npm run"
alias doc='docker-compose'
