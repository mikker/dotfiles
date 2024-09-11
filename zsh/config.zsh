# enable colored output from ls, etc
export CLICOLOR=1

fpath=($ZSH_FILES/functions $fpath)
autoload -U $ZSH_FILES/functions/*(:t)

# makes color constants available
autoload -U colors
colors

setopt no_beep # shut up
setopt auto_cd # automatically enter directories without cd
setopt multios # perform implicit tees or cats when multiple redirections are attempted

# HISTORY

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt hist_ignore_all_dups # ignore duplicate history entries
setopt inc_append_history # Appends every command to the history file once it is executed
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # Reloads the history whenever you use it

### COMPLETION

setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

zmodload -i zsh/complist

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

### PROMPT

setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt # only show the rprompt on the current prompt

setopt extendedglob
