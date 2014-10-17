" 'zenbuff.vim' -- Vim color scheme.
" Maintainer:   Mikkel Malmberg (mikkelmalmberg@me.com)
" Inspired by zenburn, built off of Apprentice

hi clear

if exists('syntax_on')
  syntax reset
endif

set background=dark

let colors_name = 'zenbuff'

if &t_Co >= 256 || has('gui_running')
  hi Normal           ctermbg=235  ctermfg=250 cterm=NONE guifg=#BCBCBC guibg=#262626 gui=NONE

  set background=dark

  hi Comment          ctermbg=NONE ctermfg=242 guifg=#626262 guibg=NONE
  hi Constant         ctermbg=NONE ctermfg=132 guifg=#AE6087 guibg=NONE
  hi Error            ctermbg=NONE ctermfg=131 guifg=#AE5F60 guibg=NONE
  hi Identifier       ctermbg=NONE ctermfg=67  guifg=#6188AD guibg=NONE
  hi Ignore           ctermbg=NONE ctermfg=235 guifg=#262626 guibg=NONE
  hi PreProc          ctermbg=NONE ctermfg=216 guifg=#FDAF8A guibg=NONE
  hi Special          ctermbg=NONE ctermfg=65  guifg=#608660 guibg=NONE
  hi Statement        ctermbg=NONE ctermfg=180 guifg=#D6AF8A guibg=NONE
  hi String           ctermbg=NONE ctermfg=174 guifg=#D58788 guibg=NONE
  hi Todo             ctermbg=NONE ctermfg=NONE cterm=reverse guifg=NONE guibg=NONE gui=reverse
  hi Type             ctermbg=NONE ctermfg=65   cterm=NONE guifg=#608660 guibg=NONE
  hi Underlined       ctermbg=NONE ctermfg=222  cterm=underline guifg=#FED68C guibg=NONE
  hi Function         ctermbg=NONE ctermfg=102  cterm=NONE guifg=#878787 guibg=NONE

  hi LineNr           ctermbg=234  ctermfg=242  guibg=#1c1c1c guifg=#6c6c6c cterm=NONE           gui=NONE
  hi NonText          ctermbg=NONE ctermfg=240  guibg=NONE    guifg=#585858 cterm=NONE           gui=NONE

  hi Pmenu            ctermbg=238  ctermfg=250  guibg=#444444 guifg=#bcbcbc cterm=NONE           gui=NONE
  hi PmenuSbar        ctermbg=240  ctermfg=NONE guibg=#585858 guifg=NONE    cterm=NONE           gui=NONE
  hi PmenuSel         ctermbg=66   ctermfg=235  guibg=#5f8787 guifg=#262626 cterm=NONE           gui=NONE
  hi PmenuThumb       ctermbg=66   ctermfg=66   guibg=#5f8787 guifg=#5f8787 cterm=NONE           gui=NONE

  hi ErrorMsg         ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi ModeMsg          ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE
  hi MoreMsg          ctermbg=NONE ctermfg=66   guibg=NONE    guifg=#5f8787 cterm=NONE           gui=NONE
  hi Question         ctermbg=NONE ctermfg=108  guibg=NONE    guifg=#87af87 cterm=NONE           gui=NONE
  hi WarningMsg       ctermbg=NONE ctermfg=131  guibg=NONE    guifg=#af5f5f cterm=NONE           gui=NONE

  hi TabLine          ctermbg=238  ctermfg=101  guibg=#444444 guifg=#87875f cterm=NONE           gui=NONE
  hi TabLineFill      ctermbg=238  ctermfg=238  guibg=#444444 guifg=#444444 cterm=NONE           gui=NONE
  hi TabLineSel       ctermbg=101  ctermfg=235  guibg=#87875f guifg=#262626 cterm=NONE           gui=NONE

  hi Cursor           ctermbg=242  ctermfg=NONE guibg=#6c6c6c guifg=NONE    cterm=NONE           gui=NONE
  hi CursorColumn     ctermbg=236  ctermfg=NONE guibg=#303030 guifg=NONE    cterm=NONE           gui=NONE
  hi CursorLine       ctermbg=236  ctermfg=NONE guibg=#303030 guifg=NONE    cterm=NONE           gui=NONE
  hi CursorLineNr     ctermbg=236  ctermfg=73   guibg=#303030 guifg=#5fafaf cterm=NONE           gui=NONE

  hi helpLeadBlank    ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=NONE           gui=NONE
  hi helpNormal       ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=NONE           gui=NONE

  hi StatusLine       ctermbg=101  ctermfg=235  guibg=#87875f guifg=#262626 cterm=NONE           gui=NONE
  hi StatusLineNC     ctermbg=238  ctermfg=101  guibg=#444444 guifg=#87875f cterm=NONE           gui=italic

  hi Visual           ctermbg=110  ctermfg=235  guibg=#8fafd7 guifg=#262626 cterm=NONE           gui=NONE
  hi VisualNOS        ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=bold,underline gui=bold,underline

  hi FoldColumn       ctermbg=234  ctermfg=242  guibg=#1c1c1c guifg=#6c6c6c cterm=NONE           gui=NONE
  hi Folded           ctermbg=234  ctermfg=242  guibg=#1c1c1c guifg=#6c6c6c cterm=NONE           gui=NONE

  hi VertSplit        ctermbg=238  ctermfg=238  guibg=#444444 guifg=#444444 cterm=NONE           gui=NONE
  hi WildMenu         ctermbg=110  ctermfg=235  guibg=#8fafd7 guifg=#262626 cterm=bold           gui=bold

  hi Function         ctermbg=NONE ctermfg=229  guibg=NONE    guifg=#ffffaf cterm=NONE           gui=NONE
  hi SpecialKey       ctermbg=NONE ctermfg=240  guibg=NONE    guifg=#585858 cterm=NONE           gui=NONE
  hi Title            ctermbg=NONE ctermfg=231  guibg=NONE    guifg=#ffffff cterm=bold           gui=NONE

  hi DiffAdd          ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE
  hi DiffChange       ctermbg=60   ctermfg=235  guibg=#5f5f87 guifg=#262626 cterm=NONE           gui=NONE
  hi DiffDelete       ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi DiffText         ctermbg=103  ctermfg=235  guibg=#8787af guifg=#262626 cterm=NONE           gui=NONE

  hi IncSearch        ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi Search           ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE

  hi Directory        ctermbg=NONE ctermfg=73   guibg=NONE    guifg=#5fafaf cterm=NONE           gui=NONE
  hi MatchParen       ctermbg=NONE ctermfg=229  guibg=NONE    guifg=#ffffaf cterm=bold           gui=NONE

  hi SpellBad         ctermbg=NONE ctermfg=131  guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#af5f5f
  hi SpellCap         ctermbg=NONE ctermfg=73   guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#5fafaf
  hi SpellLocal       ctermbg=NONE ctermfg=65   guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#5f875f
  hi SpellRare        ctermbg=NONE ctermfg=208  guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#ff8700

  hi ColorColumn      ctermbg=131  ctermfg=NONE guibg=#af5f5f guifg=NONE    cterm=NONE           gui=NONE
  hi signColumn       ctermbg=234  ctermfg=242  guibg=#1c1c1c guifg=#6c6c6c cterm=NONE           gui=NONE
endif

hi link Boolean            Constant
hi link Character          Constant
hi link Conceal            Normal
hi link Conditional        Statement
hi link Debug              Special
hi link Define             PreProc
hi link Delimiter          Special
hi link Exception          Statement
hi link Float              Number
hi link HelpCommand        Statement
hi link HelpExample        Statement
hi link Include            PreProc
hi link Keyword            Statement
hi link Label              Statement
hi link Macro              PreProc
hi link Number             Constant
hi link Operator           Statement
hi link PreCondit          PreProc
hi link Repeat             Statement
hi link SpecialChar        Special
hi link SpecialComment     Special
hi link StorageClass       Type
hi link Structure          Type
hi link Tag                Special
hi link Typedef            Type

hi link htmlEndTag         htmlTagName
hi link htmlLink           Function
hi link htmlSpecialTagName htmlTagName
hi link htmlTag            htmlTagName

hi link diffBDiffer        WarningMsg
hi link diffCommon         WarningMsg
hi link diffDiffer         WarningMsg
hi link diffIdentical      WarningMsg
hi link diffIsA            WarningMsg
hi link diffNoEOL          WarningMsg
hi link diffOnly           WarningMsg
hi link diffRemoved        WarningMsg
hi link diffAdded          String
