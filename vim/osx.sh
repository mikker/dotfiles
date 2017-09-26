# Make c-h work in neovim
# https://github.com/neovim/neovim/issues/2048#issuecomment-78045837
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
echo 'tic $TERM.ti' >> ~/.localrc
