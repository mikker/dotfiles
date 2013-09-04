# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# Clear LSCOLORS
unset LSCOLORS

# Main change, you can see directories on a dark background
# export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS=exfxcxdxbxegedabagacad

