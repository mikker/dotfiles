filetype plugin indent on

set nobackup
set nowritebackup
set noswapfile
set directory=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
if exists('+undofile')
  set undofile
  set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

set history=10000
set undolevels=1000

set mouse=nvi " enable mouse
set cursorline " highlight current line
set hidden " allow buffers in background
set number " line numbers
set listchars=tab:»·,trail:· " invisible chars
set list " show tabs and trailing whitespace

" set wildmode=longest:list,full " tab completion
set laststatus=2 " always show status bar
set wildignorecase " ignore case when completing filenames in command mode
set ignorecase smartcase " search is case insensitive unless when upper case
set gdefault " global search by default; /g for first-per-row only.

set autoindent " indent to current depth on new lines
set expandtab " spaces for tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2
set foldlevel=999 " folds come expanded

set autoread " update files when coming back

set exrc " auto load local .vimrc files
set secure " … but lets keep it secure

" brew install ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep
endif
