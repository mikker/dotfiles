" Name:       pelts.vim
" Version:    0.1.0
" Maintainer: github.com/mikker
" License:    The MIT License (MIT)
"
" A minimal colorscheme for Vim
"
"""
hi clear

if exists('syntax on')
  syntax reset
endif

let g:colors_name='pelts'

let s:midnight_blue = ['#121e2a', 232]
let s:chambray = ['#203149', 234]
let s:paper = ['#c0bdb3', 230]
let s:black  = ['#111111', 233]

let s:default_fg = s:paper
let s:default_bg = s:midnight_blue

let s:italic    = 'italic'
let s:bold      = 'bold'
let s:underline = 'underline'
let s:none      = 'NONE'

let s:default_lst = []
let s:default_str = ''

function! s:hi(...)
  let group = a:1
  let fg    = get(a:, 2, s:default_fg)
  let bg    = get(a:, 3, s:default_bg)
  let attr  = get(a:, 4, s:default_str)

  let cmd = ['hi', group]

  if fg != s:default_lst
    call add(cmd, 'guifg='.fg[0])
    call add(cmd, 'ctermfg='.fg[1])
  endif

  if bg != s:default_lst && bg != s:default_bg
    call add(cmd, 'guibg='.bg[0])
    call add(cmd, 'ctermbg='.bg[1])
  endif

  if attr != s:default_str
    call add(cmd, 'gui='.attr)
    call add(cmd, 'cterm='.attr)
  endif
  exec join(cmd, ' ')
endfunction

" -
" --- INTERFACE
" -

call s:hi('Normal')
call s:hi('Cursor', s:default_bg, s:default_fg)
call s:hi('CursorLine', s:default_lst, s:chambray, s:none)
call s:hi('CursorLineNr')
call s:hi('ColorColumn')
call s:hi('Search')
call s:hi('Visual')
call s:hi('ErrorMsg')

call s:hi('NonText')

" Folds
call s:hi('FoldColumn')
call s:hi('Folded')
" Line numbers gutter.
call s:hi('LineNr')
" Small arrow used for tabs.
call s:hi('SpecialKey')
" File browsers.
call s:hi('Directory')
" Help.
call s:hi('helpSpecial')
call s:hi('helpHyperTextJump')
call s:hi('helpNote')
" Popup menu.
call s:hi('Pmenu')
call s:hi('PmenuSel')
" Notes.
call s:hi('Todo')
" Signs.
call s:hi('SignColumn')

call s:hi('Statement')
call s:hi('PreProc')
call s:hi('String')
call s:hi('Comment')
call s:hi('Constant')
call s:hi('Type')
call s:hi('Function')
call s:hi('Identifier')
call s:hi('Special')
call s:hi('MatchParen')


"
" --- VimL ---------------------------------------------------------------------
"
call s:hi('vimOption')
call s:hi('vimGroup')
call s:hi('vimHiClear')
call s:hi('vimHiGroup')
call s:hi('vimHiAttrib')
call s:hi('vimHiGui')
call s:hi('vimHiGuiFgBg')
call s:hi('vimHiCTerm')
call s:hi('vimHiCTermFgBg')
call s:hi('vimSynType')
hi link vimCommentTitle Comment
"
" --- Ruby ---------------------------------------------------------------------
"
call s:hi('rubyConstant')
call s:hi('rubySharpBang')
call s:hi('rubyStringDelimiter')
call s:hi('rubyStringEscape')
call s:hi('rubyRegexpEscape')
call s:hi('rubyRegexpAnchor')
call s:hi('rubyRegexpSpecial')


