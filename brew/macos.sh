if [ ! -x /usr/local/bin/brew ]; then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install \
  aria2 \
  chruby \
  ctags \
  curl \
  exa \
  fzf \
  imagemagick \
  git \
  hub \
  mas \
  mosh \
  node \
  postgresql \
  python2 \
  python3 \
  reattach-to-user-namespace \
  redis \
  ripgrep \
  ruby-install \
  ssh-copy-id \
  tmux \
  tree \
  vim \
  wget \
  yarn \
  youtube-dl \
  zsh

brew install weechat \
  --with-curl --with-lua --with-perl --with-python --with-ruby

brew install neovim --HEAD

brew cask install \
  caskroom/versions/iterm2-nightly \
  dash \
  day-o \
  dropshare \
  encryptme \
  firefox \
  firefox-nightly \
  google-chrome \
  gpg-suite \
  hammerspoon \
  imageoptim \
  ngrok \
  putio-adder \
  quicksilver \
  sketch \
  slack \
  spotify \
  superduper \
  textexpander5 \
  transmit \
  vimr \
  visual-studio-code \
  vlc \
  zoomus

brew tap caskroom/fonts
brew cask install \
  font-courier-prime-code \
  font-courier-prime \
  font-cousine \
  font-dejavu-sans \
  font-fantasque-sans-mono \
  font-fira-code \
  font-fira-sans \
  font-inconsolata \
  font-input \
  font-iosevka \
  font-lekton \
  font-liberation-sans \
  font-monoid \
  font-mononoki \
  font-roboto \
  font-roboto-mono \
  font-roboto-condensed

