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
  hi Normal           ctermbg=235  ctermfg=250 cterm=NONE

  set background=dark

  hi Comment          ctermbg=NONE ctermfg=65
  hi Constant         ctermbg=NONE ctermfg=132
  hi Error            ctermbg=NONE ctermfg=131
  hi Identifier       ctermbg=NONE ctermfg=222
  hi Ignore           ctermbg=NONE ctermfg=235
  hi PreProc          ctermbg=NONE ctermfg=216
  hi Special          ctermbg=NONE ctermfg=65
  hi Statement        ctermbg=NONE ctermfg=180
  hi String           ctermbg=NONE ctermfg=174
  hi Todo             ctermbg=NONE ctermfg=NONE cterm=reverse
  hi Type             ctermbg=NONE ctermfg=66   cterm=NONE
  hi Underlined       ctermbg=NONE ctermfg=222  cterm=underline
  hi Function         ctermbg=NONE ctermfg=228  cterm=NONE

  hi LineNr           ctermbg=234  ctermfg=242  cterm=NONE
  hi NonText          ctermbg=NONE ctermfg=240  cterm=NONE

  hi Pmenu            ctermbg=238  ctermfg=250  cterm=NONE
  hi PmenuSbar        ctermbg=240  ctermfg=NONE cterm=NONE
  hi PmenuSel         ctermbg=222  ctermfg=235  cterm=NONE
  hi PmenuThumb       ctermbg=222  ctermfg=222  cterm=NONE

  hi ErrorMsg         ctermbg=131  ctermfg=235  cterm=NONE
  hi ModeMsg          ctermbg=108  ctermfg=235  cterm=NONE
  hi MoreMsg          ctermbg=NONE ctermfg=222  cterm=NONE
  hi Question         ctermbg=NONE ctermfg=108  cterm=NONE
  hi WarningMsg       ctermbg=NONE ctermfg=131  cterm=NONE

  hi Cursor           ctermbg=242  ctermfg=NONE cterm=NONE
  hi CursorColumn     ctermbg=236  ctermfg=NONE cterm=NONE
  hi CursorLine       ctermbg=236  ctermfg=NONE cterm=NONE
  hi CursorLineNr     ctermbg=236  ctermfg=74   cterm=NONE

  hi StatusLine       ctermbg=242  ctermfg=235 cterm=NONE
  hi StatusLineNC     ctermbg=238  ctermfg=101 cterm=NONE

  hi Visual           ctermbg=229  ctermfg=235  cterm=NONE
  hi VisualNOS        ctermbg=NONE ctermfg=NONE cterm=bold,underline

  hi FoldColumn       ctermbg=234  ctermfg=242 cterm=NONE
  hi Folded           ctermbg=234  ctermfg=242 cterm=NONE

  hi VertSplit        ctermbg=238  ctermfg=238 cterm=NONE

  hi DiffAdd          ctermbg=108  ctermfg=235 cterm=NONE
  hi DiffChange       ctermbg=60   ctermfg=235 cterm=NONE
  hi DiffDelete       ctermbg=131  ctermfg=235 cterm=NONE
  hi DiffText         ctermbg=66   ctermfg=235 cterm=NONE

  hi IncSearch        ctermbg=131  ctermfg=235 cterm=NONE
  hi Search           ctermbg=108  ctermfg=235 cterm=NONE

  hi Directory        ctermbg=NONE ctermfg=74   cterm=NONE
  hi MatchParen       ctermbg=NONE ctermfg=228  cterm=bold

  hi SpellBad         ctermbg=NONE ctermfg=131  cterm=undercurl
  hi SpellCap         ctermbg=NONE ctermfg=74   cterm=undercurl
  hi SpellLocal       ctermbg=NONE ctermfg=65   cterm=undercurl
  hi SpellRare        ctermbg=NONE ctermfg=132  cterm=undercurl

  hi ColorColumn      ctermbg=131  ctermfg=NONE cterm=NONE
  hi signColumn       ctermbg=234  ctermfg=242  cterm=NONE
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
