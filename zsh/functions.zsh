# p()
# Quickly navigate to a project - with autocorrect
p() { cd ~/Projects/$1; }
_p() { _files -W ~/Projects -/; }
compdef _p p

# p()
# Quickly navigate to a project - with autocorrect
c() { cd ~/Developer/code/$1; }
_c() { _files -W ~/Developer/code -/; }
compdef _c c

# o()
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
sdate() { date +%Y.%m.%d }
# make a dir, cd into it
mdc() { mkdir -p "$1" && cd "$1" }

# -------------------------------------------------------------------
# compressed file expander
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2) tar xvjf $1;;
      *.tar.gz) tar xvzf $1;;
      *.tar.xz) tar xvJf $1;;
      *.tar.lzma) tar --lzma xvf $1;;
      *.bz2) bunzip $1;;
      *.rar) unrar $1;;
      *.gz) gunzip $1;;
      *.tar) tar xvf $1;;
      *.tbz2) tar xvjf $1;;
      *.tgz) tar xvzf $1;;
      *.zip) unzip $1;;
      *.Z) uncompress $1;;
      *.7z) 7z x $1;;
      *.dmg) hdiutul mount $1;; # mount OS X disk images
        *) echo "'$1' cannot be extracted via >ex<";;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# prints the absolute path of a file
abspath() {
  find `pwd` -name "$@"
}

fun dsay() {
  wget -q -U Mozilla -O output.mp3 "http://translate.google.com/translate_tts?ie=UTF-8&tl=da&q=$*"
  open output.mp3
}
