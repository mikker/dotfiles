rm -rf ~/.profile ~/.bashrc ~/.gitconfig ~/.gemrc ~/.irbrc ~/.screenrc
ln -s `pwd`/bashrc ~/.bashrc
ln -s ~/.bashrc ~/.profile
ln -s `pwd`/gemrc ~/.gemrc
ln -s `pwd`/irbrc ~/.irbrc
ln -s `pwd`/gitprofile ~/.gitconfig
ln -s `pwd`/screenrc ~/.screenrc