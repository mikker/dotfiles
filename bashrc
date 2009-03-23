# =======
# = Git =
# =======
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ @\1$(parse_git_dirty)/"
}
source ~/dotfiles/git-completion.bash
alias st='git st'
alias ci='git ci -m'
alias add='git add'
alias gx='gitx'

# =======
# = PS1 =
# =======
PS1='\[\e[1;34m\]>\[\e[m\]\[\e[1;33m\]$(parse_git_branch)\[\e[0;31m\]:\[\e[m\] ' # branch
#PS1='\[\e[1;34m\]\W\[\e[m\]\[\e[1;33m\]$(parse_git_branch)\[\e[0;31m\]:\[\e[m\] ' # path branch
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\W\[\e[m\]\[\e[1;33m\]$(parse_git_branch) \[\e[0;31m\]:\[\e[m\] ' # user path branch

# ========
# = Misc =
# ========
alias ls="ls -Gh"
alias apachectl="sudo apachectl"
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

# =========
# = Rails =
# =========
# Scripts folder
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'
alias sd='script/destroy'
alias sp='script/plugin'
alias scdb='script/dbconsole'
# Migrations
alias migrate='rake db:migrate; rake db:test:clone'
alias remigrate='rake db:migrate:redo'
# Logs
alias tl='tail -f log/development.log'

# ========
# = Merb =
# ========
alias mg='merb-gen'
alias merbmigrate='rake db:autoupgrade;rake db:autoupgrade MERB_ENV=test'

# ========
# = Ruby =
# ========
# Webby
alias wa='webby autobuild'
alias w?='webby -T'
# Test
alias at='autotest'
alias as='autospec'
# Rake
alias r?='rake -T'
complete -C ~/dotfiles/rake-completion.rb -o default rake
# IRB
alias irb='irb --readline -r irb/completion -rubygems'
# Passenger
alias re='touch tmp/restart.txt'
# Gems
alias gemi="sudo gem install --no-ri"

# =================
# = Shell history =
# =================
# see http://blog.macromates.com/2008/working-with-history-in-bash/
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend cdspell
# Huh?
bind Space:magic-space
# Search history
alias h="history"
alias h?="history | grep"

PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=/Users/mikker/bin:$PATH



alias wiki='gaze ~/Dropbox/Txts'
alias vhost='mate /etc/hosts && mate /etc/apache2/extra/httpd-vhosts.conf'