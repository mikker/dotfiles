rm -rf ~/.profile ~/.bashrc ~/.gitconfig ~/.gemrc ~/.irbrc ~/.screenrc
ln -fs `pwd`/bashrc ~/.bashrc
ln -fs ~/.bashrc ~/.profile
ln -fs `pwd`/gemrc ~/.gemrc
ln -fs `pwd`/irbrc ~/.irbrc
ln -fs `pwd`/gitconfig ~/.gitconfig
ln -fs `pwd`/screenrc ~/.screenrc