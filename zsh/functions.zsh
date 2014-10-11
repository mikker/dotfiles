# Quickly navigate to a project - with autocorrect
c() { cd ~/Developer/$1; }
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

dsay() {
  wget -q -U Mozilla -O output.mp3 "http://translate.google.com/translate_tts?ie=UTF-8&tl=da&q=$*"
  open output.mp3
}

# Open argument in Dash
dash() { open "dash://$*" }

# Make a new tmux window and run $@ in it
nw() { tmux new-window && tmux send-keys "$*" C-m }

# Download pasteboard
aripb() { aria2c "`pbpaste`" }
