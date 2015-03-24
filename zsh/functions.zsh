# Quickly navigate to a project - with autocorrect
c() {
  if [[ $# == 0 ]]; then
    # brew install selecta
    cd $(find ~/Developer -type d -maxdepth 3 | pick)
  else
    cd ~/Developer/$1;
  fi
}
_c() { _files -W ~/Developer -/; }
compdef _c c

# Open a file or the current directory
o() {
  if [[ $# > 0 ]]; then
    open $@
  else
    open .
  fi
}

mkcd() {
  mkdir -p "$@" && cd "$@"
}

# nb()
# Checkout new (or existing) branch of name ...
nb() {
  if [[ $# > 0 ]]; then
    if [[ $(git branch | tr -d '* ' | grep "$1") != "" ]]; then
      git checkout $1
    else
      git checkout master && git checkout -b $1
    fi
  else
    git branch | tr -d '* '
  fi
}
_nb() { reply=($(git branch | tr -d '* ' | xargs echo)) }
compctl -K _nb nb

# simplest date
sdate() { date +%Y-%m-%d }

# prints the absolute path of a file
abspath() { find `pwd` -name "$@" }

# Make your Mac say things (in Danish)
dsay() { say -v Sara $@ }

# Open argument in Dash
dash() { open "dash://$*" }

# Make a new tmux window and run $@ in it
nw() { tmux new-window && tmux send-keys "$*" C-m }

# Download pasteboard using aria2 download thing
aripb() { echo `pbpaste` && aria2c "`pbpaste`" }

dokku-fn() {
  if [[ $# < 1 ]]; then
    echo "Usage: dokku CMD"; return 1
  fi
  if [ -e $DOKKU_HOST ]; then
    echo "No \$DOKKU_HOST"; return 1
  fi

  cmd=$1
  shift

  if [ ! -e .app ]; then
    name=$(basename `pwd`)
    echo "Notice: Setting app to $name"
    echo $name > .app
  fi

  app=`cat .app`

  ssh -t $DOKKU_HOST $cmd $app $@
}
