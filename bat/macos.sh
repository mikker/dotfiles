mkdir -p ~/.config/bat
rm -rf ~/.config/bat/themes
ln -sf ~/.dotfiles/bat/themes ~/.config/bat/themes
ln -sf ~/.dotfiles/bat/config ~/.config/bat/config
bat cache --build
