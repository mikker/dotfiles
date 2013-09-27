# General
alias so='source'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'

# tmux
alias t="tmux -u"

# Git
alias g='git'
alias gp='git push'
alias gu='git pull'
alias ga='git add --all'
alias gd='git diff'
alias gl='git tree'
alias gla='git tree --all'
alias gdt='git difftool'
alias gmt='git mergetool'
alias ms='git checkout master'
alias up='git checkout master && git pull && git checkout -'
alias st='git status'
alias ci='git commit -m'
# Hub
alias gb='hub browse'
alias gpr='hub pull-request'
alias last_commit_message='git --no-pager log -1 --pretty=%B | sed -e "s/^ *//g" -e "s/ *$//g" | tr -d "\n"'
alias prl='gp -u && gpr "`last_commit_message`" | pbcopy && open `pbpaste`'

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
alias tl='tail -f log/development.log'
# Gems
alias mm='bundle exec middleman'
# Foreman
alias fs='bundle exec foreman start'

if [ is_mac ]; then
  alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
fi
