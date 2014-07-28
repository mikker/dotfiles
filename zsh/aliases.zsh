# General
alias so='source'
alias l='ls'
alias ll='ls -lh'
alias la='ls -a'

# tmux
alias t="tmux -u"
alias ta='tmux attach'
alias tat='tmux new-session -As `basename $PWD`'
alias tk='tmux kill-session'
alias tmux-set-title="tmux rename-session \`basename \$(pwd)\`"

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
alias st='git status -sb'
alias ci='git commit -m'
alias ms='git checkout master'
alias up='git checkout master && git fetch && git rebase origin && git checkout -'
alias delete_merged_branches='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
# Hub
alias gb='hub browse'
alias gpr='hub pull-request'

# Rack
alias re='touch tmp/restart.txt'
# Bundler
alias be='bundle exec'
# Rails 3+
alias rg='bundle exec rails generate'
alias rc='bundle exec rails console'
alias rs='bundle exec rails server'
alias rd='bundle exec rails destroy'
# Rails
alias migrate='bundle exec rake db:migrate db:test:prepare'
alias remigrate='bundle exec rake db:migrate:redo db:test:prepare'
alias tl='tail -F log/development.log'
alias tp='tail -F log/production.log'
# Foreman
alias fs='bundle exec foreman start'

if [ is_mac ]; then
  alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
fi
alias mailsize="du -hs ~/Library/mail"

alias pu='pushd'
alias po='popd'

alias pyg='pygmentize -g'
alias md='open -a Marked'
alias json='python -mjson.tool'
alias pweb='python -m SimpleHTTPServer'
alias batt="pmset -g batt | sed '1d' | sed -e 's/-InternalBattery-0//' | awk '{\$1=\$1}1'"

alias safari_address="osascript -e 'tell application \"Safari\" to return URL of current tab of front window'"
alias mm='bundle exec middleman'

alias temp="/Applications/TemperatureMonitor.app/Contents/MacOS/tempmonitor -c -l -a"
