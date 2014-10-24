" Vim color file
" Name:    xoria256.vim
" Version:  0.3.2
" License:  Public Domain
" Maintainer:  Dmitriy Y. Zotikov (xio) <xio@ungrund.org>

if &t_Co != 256 && ! has("gui_running")
  echomsg ""
  echomsg "err: please use GUI or a 256-color terminal (so that t_Co=256 could be set)"
  echomsg ""
  finish
endif

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

" Which one is right?
let g:colors_name = "xoria256"

hi Normal  cterm=none  ctermfg=252  ctermbg=235  gui=none  guifg=#d0d0d0  guibg=#202020

hi Cursor  cterm=none  ctermfg=bg  ctermbg=214  gui=none  guifg=bg  guibg=#ffaf00
hi CursorColumn  cterm=none      ctermbg=238  gui=none      guibg=#444444
hi CursorLine  cterm=none      ctermbg=238  gui=none      guibg=#444444
hi lCursor  cterm=none  ctermfg=0  ctermbg=40  gui=none  guifg=#000000  guibg=#00df00
hi IncSearch  cterm=none  ctermfg=0  ctermbg=223  gui=none  guifg=#000000  guibg=#ffdfaf
hi Search  cterm=none  ctermfg=0  ctermbg=149  gui=none  guifg=#000000  guibg=#afdf5f
hi ErrorMsg  cterm=none  ctermfg=15  ctermbg=160  gui=bold  guifg=#ffffff  guibg=#df0000
hi WarningMsg  cterm=bold  ctermfg=196  ctermbg=bg  gui=bold  guifg=#ff0000  guibg=bg
hi ModeMsg  cterm=bold  ctermfg=fg  ctermbg=bg  gui=bold  guifg=fg  guibg=bg
hi MoreMsg  cterm=bold  ctermfg=250  ctermbg=bg  gui=bold  guifg=#bcbcbc  guibg=bg
hi Question  cterm=bold  ctermfg=113  ctermbg=bg  gui=bold  guifg=#87df7f  guibg=bg

hi StatusLine  cterm=bold  ctermfg=fg  ctermbg=239  gui=bold  guifg=fg  guibg=#4e4e4e
hi StatusLineNC  cterm=none  ctermfg=fg  ctermbg=237  gui=none  guifg=fg  guibg=#3a3a3a
hi User1  cterm=none  ctermfg=15  ctermbg=20  gui=none  guifg=#ffffff  guibg=#0000df
hi User2  cterm=none  ctermfg=46  ctermbg=20  gui=none  guifg=#00ff00  guibg=#0000df
hi User3  cterm=none  ctermfg=46  ctermbg=20  gui=none  guifg=#00ff00  guibg=#0000df
hi User4  cterm=none  ctermfg=50  ctermbg=20  gui=none  guifg=#00ffdf  guibg=#0000df
hi User5  cterm=none  ctermfg=46  ctermbg=20  gui=none  guifg=#00ff00  guibg=#0000df
hi VertSplit  cterm=reverse  ctermfg=fg  ctermbg=237  gui=reverse  guifg=fg  guibg=#3a3a3a

hi WildMenu  cterm=bold  ctermfg=0  ctermbg=184  gui=bold  guifg=#000000  guibg=#dfdf00
hi Folded  cterm=none  ctermfg=255  ctermbg=60  gui=none  guifg=#eeeeee  guibg=#5f5f87
hi FoldColumn  cterm=none  ctermfg=248  ctermbg=58  gui=none  guifg=#a8a8a8  guibg=bg
hi SignColumn  cterm=none  ctermfg=248  ctermbg=bg  gui=none  guifg=#a8a8a8  guibg=bg

hi Directory  cterm=none  ctermfg=39  ctermbg=bg  gui=none  guifg=#00afff  guibg=bg
hi LineNr  cterm=none  ctermfg=248      gui=none  guifg=#a8a8a8
hi NonText  cterm=bold  ctermfg=248  ctermbg=bg  gui=bold  guifg=#a8a8a8  guibg=bg
hi SpecialKey  cterm=none  ctermfg=77  ctermbg=bg  gui=none  guifg=#5fdf5f  guibg=bg
hi Visual  cterm=none  ctermfg=24  ctermbg=153  gui=none  guifg=#005f87  guibg=#afdfff
hi VisualNOS  cterm=bold,underline ctermfg=247 ctermbg=bg  gui=bold,underline guifg=#9e9e9e guibg=bg

hi Comment  cterm=none  ctermfg=244  ctermbg=bg  gui=none  guifg=#808080  guibg=bg
hi Constant  cterm=none  ctermfg=187  ctermbg=bg  gui=none  guifg=#dfdfaf  guibg=bg
hi Error  cterm=none  ctermfg=196  ctermbg=bg  gui=none  guifg=#ff0000  guibg=bg
hi Identifier  cterm=none  ctermfg=150  ctermbg=bg  gui=none  guifg=#afdf87  guibg=bg
hi Ignore  cterm=none  ctermfg=238  ctermbg=bg  gui=none  guifg=#444444  guibg=bg
hi Number  cterm=none  ctermfg=180  ctermbg=bg  gui=none  guifg=#dfaf87  guibg=bg
hi PreProc  cterm=none  ctermfg=182  ctermbg=bg  gui=none  guifg=#dfafdf  guibg=bg
hi Special  cterm=none  ctermfg=174  ctermbg=bg  gui=none  guifg=#df8787  guibg=bg
hi Statement  cterm=none  ctermfg=74  ctermbg=bg  gui=none  guifg=#5fafdf  guibg=bg
hi Todo    cterm=none  ctermfg=0  ctermbg=184  gui=none  guifg=#000000  guibg=#dfdf00
hi Type    cterm=none  ctermfg=146  ctermbg=bg  gui=none  guifg=#afafdf  guibg=bg
hi Underlined  cterm=underline  ctermfg=39  ctermbg=bg  gui=underline  guifg=#00afff  guibg=bg

" For features in vim v.7.0 and higher
if v:version >= 700
  hi Pmenu      cterm=none  ctermfg=0  ctermbg=246  gui=none  guifg=#000000  guibg=#949494
  hi PmenuSel   cterm=none  ctermfg=0  ctermbg=243  gui=none  guifg=#000000  guibg=#767676
  hi PmenuSbar  cterm=none  ctermfg=fg  ctermbg=243  gui=none  guifg=fg  guibg=#767676
  hi PmenuThumb cterm=none  ctermfg=bg  ctermbg=252  gui=none  guifg=bg  guibg=#d0d0d0

  hi MatchParen  cterm=none  ctermfg=188  ctermbg=68  gui=bold  guifg=#dfdfdf  guibg=#5f87df
  hi TabLineSel  cterm=bold  ctermfg=fg  ctermbg=bg  gui=bold  guifg=fg  guibg=bg
  hi TabLine  cterm=underline  ctermfg=fg  ctermbg=242  gui=underline  guifg=fg  guibg=#666666
  hi TabLineFill cterm=underline ctermfg=fg  ctermbg=242  gui=underline  guifg=fg  guibg=#666666
endif

hi DiffAdd          ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE
hi DiffChange       ctermbg=60   ctermfg=235  guibg=#5f5f87 guifg=#262626 cterm=NONE           gui=NONE
hi DiffDelete       ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
hi DiffText         ctermbg=103  ctermfg=235  guibg=#8787af guifg=#262626 cterm=NONE           gui=NONE

