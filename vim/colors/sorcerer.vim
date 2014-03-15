" 'sorcerer.vim' -- Vim color scheme.
" Maintainer:   Jeet Sukumaran
" Based on 'Mustang' by Henrique C. Alves (hcarvalhoalves@gmail.com)
" Modified and ported to 256 colors term by romainl.

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "sorcerer"

hi Normal             term=NONE cterm=NONE ctermbg=234 ctermfg=145 gui=NONE guibg=#202020 guifg=#c2c2b0
hi Boolean            term=NONE cterm=NONE ctermbg=bg ctermfg=208 gui=NONE guibg=bg guifg=#ff9800
hi ColorColumn        term=reverse cterm=NONE ctermbg=234 ctermfg=fg gui=NONE guibg=#1c1c1c guifg=fg
hi Comment            term=bold cterm=NONE ctermbg=bg ctermfg=240 gui=italic guibg=bg guifg=#707670
hi Conceal            term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
hi Constant           term=underline cterm=NONE ctermbg=bg ctermfg=208 gui=NONE guibg=bg guifg=#ff9800
hi Directory          term=bold cterm=NONE ctermbg=234 ctermfg=33 gui=NONE guibg=#202020 guifg=#1e90ff
hi Error              term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
hi Function           term=NONE cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#faf4c6
hi Identifier         term=underline cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi Ignore             term=NONE cterm=NONE ctermbg=bg ctermfg=234 gui=NONE guibg=bg guifg=#202020
hi IncSearch          term=reverse cterm=bold ctermbg=202 ctermfg=231 gui=bold guibg=#ff4500 guifg=#ffffff
hi Keyword            term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi LineNr             term=underline cterm=NONE ctermbg=233 ctermfg=59 gui=NONE guibg=#101010 guifg=#686858
hi MatchParen         term=reverse cterm=bold ctermbg=16 ctermfg=226 gui=bold guibg=#000000 guifg=#fff000
hi NonText            term=bold cterm=NONE ctermbg=234 ctermfg=238 gui=NONE guibg=#202020 guifg=#444444
hi Number             term=NONE cterm=NONE ctermbg=bg ctermfg=172 gui=NONE guibg=bg guifg=#cc8800
hi PreProc            term=underline cterm=NONE ctermbg=bg ctermfg=66 gui=NONE guibg=bg guifg=#528b8b
hi Question           term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ee00
hi Search             term=reverse cterm=bold ctermbg=185 ctermfg=16 gui=bold guibg=#d6e770 guifg=#000000
hi SignColumn         term=NONE cterm=NONE ctermbg=187 ctermfg=231 gui=NONE guibg=#cdcdb4 guifg=#ffffff
hi Special            term=bold cterm=NONE ctermbg=bg ctermfg=64 gui=NONE guibg=bg guifg=#719611
hi SpecialKey         term=bold cterm=NONE ctermbg=bg ctermfg=238 gui=NONE guibg=bg guifg=#444444
hi Statement          term=bold cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi String             term=NONE cterm=NONE ctermbg=bg ctermfg=65 gui=NONE guibg=bg guifg=#779b70
hi Title              term=bold cterm=bold ctermbg=bg ctermfg=66 gui=bold guibg=bg guifg=#528b8b
hi Todo               term=NONE cterm=bold,underline ctermbg=234 ctermfg=96 gui=bold,italic,underline guibg=#202020 guifg=#8f6f8f
hi Type               term=underline cterm=NONE ctermbg=bg ctermfg=103 gui=NONE guibg=bg guifg=#7e8aa2
hi Underlined         term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
hi VertSplit          term=reverse cterm=NONE ctermbg=59 ctermfg=59 gui=NONE guibg=#5f5f5f guifg=#5f5f5f
hi WildMenu           term=NONE cterm=NONE ctermbg=116 ctermfg=16 gui=NONE guibg=#87ceeb guifg=#000000

hi Pmenu              term=NONE cterm=NONE ctermbg=238 ctermfg=231 gui=NONE guibg=#444444 guifg=#ffffff
hi PmenuSel           term=NONE cterm=NONE ctermbg=149 ctermfg=16 gui=NONE guibg=#b1d631 guifg=#000000
hi PmenuSbar          term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
hi PmenuThumb         term=NONE cterm=NONE ctermbg=149 ctermfg=149 gui=NONE guibg=#b1d631 guifg=#b1d631

hi ErrorMsg           term=NONE cterm=bold ctermbg=bg ctermfg=203 gui=bold guibg=bg guifg=#ff6a6a
hi MoreMsg            term=bold cterm=bold ctermbg=234 ctermfg=29 gui=bold guibg=#202020 guifg=#2e8b57
hi ModeMsg            term=bold cterm=bold ctermbg=46 ctermfg=16 gui=bold guibg=#00ff00 guifg=#000000
hi WarningMsg         term=NONE cterm=NONE ctermbg=234 ctermfg=208 gui=NONE guibg=#202020 guifg=#ee9a00

hi TabLine            term=underline cterm=NONE ctermbg=234 ctermfg=59 gui=NONE guibg=#202020 guifg=#686858
hi TabLineSel         term=bold cterm=bold ctermbg=145 ctermfg=234 gui=bold guibg=#c2c2b0 guifg=#202020
hi TabLineFill        term=reverse cterm=reverse ctermbg=145 ctermfg=234 gui=reverse guibg=#202020 guifg=#c2c2b0

hi Cursor             term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#626262 guifg=fg
hi lCursor            term=NONE cterm=NONE ctermbg=145 ctermfg=234 gui=NONE guibg=#c2c2b0 guifg=#202020
hi CursorColumn       term=reverse cterm=NONE ctermbg=236 ctermfg=NONE gui=NONE guibg=#2d2d2d guifg=NONE
hi CursorLine         term=underline cterm=NONE ctermbg=236 ctermfg=NONE gui=NONE guibg=#333333 guifg=NONE

hi helpLeadBlank      term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
hi helpNormal         term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg

hi StatusLine         term=bold,reverse cterm=bold ctermbg=101 ctermfg=16 gui=bold guibg=#87875f  guifg=#000000
hi StatusLineNC       term=reverse cterm=NONE ctermbg=59 ctermfg=16 gui=italic guibg=#5f5f5f guifg=#000000

hi Visual             term=reverse cterm=NONE ctermbg=67 ctermfg=16 gui=NONE guibg=#6688aa guifg=#000000
hi VisualNOS          term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg

hi Folded             term=NONE cterm=NONE ctermbg=59 ctermfg=110 gui=NONE guibg=#40403c guifg=#99aacc
hi FoldColumn         term=NONE cterm=bold ctermbg=236 ctermfg=66 gui=bold guibg=#303030 guifg=#68838b

hi SpellBad           term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ee2c2c
hi SpellCap           term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
hi SpellLocal         term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=#008b8b
hi SpellRare          term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff

hi diffOldFile        term=NONE cterm=NONE ctermbg=bg ctermfg=170 gui=italic guibg=bg guifg=#da70d6
hi diffNewFile        term=NONE cterm=NONE ctermbg=bg ctermfg=226 gui=italic guibg=bg guifg=#ffff00
hi diffFile           term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=italic guibg=bg guifg=#ffa500
hi diffLine           term=NONE cterm=NONE ctermbg=bg ctermfg=201 gui=italic guibg=bg guifg=#ff00ff
hi diffRemoved        term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cd5555
hi diffChanged        term=NONE cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#4f94cd
hi diffAdded          term=NONE cterm=NONE ctermbg=bg ctermfg=40 gui=NONE guibg=bg guifg=#00cd00
hi DiffAdd            term=bold cterm=NONE ctermbg=71 ctermfg=16 gui=NONE guibg=#3cb371 guifg=#000000
hi DiffChange         term=bold cterm=NONE ctermbg=68 ctermfg=16 gui=NONE guibg=#4f94cd guifg=#000000
hi DiffDelete         term=bold cterm=NONE ctermbg=94 ctermfg=16 gui=NONE guibg=#8b3626 guifg=#000000
hi DiffText           term=reverse cterm=NONE ctermbg=117 ctermfg=16 gui=NONE guibg=#8ee5ee guifg=#000000

hi javaScriptOpAssign term=NONE cterm=NONE ctermbg=bg ctermfg=176 gui=NONE guibg=bg guifg=#cc99cc

hi pythonDecorator    term=NONE cterm=NONE ctermbg=bg ctermfg=101 gui=NONE guibg=bg guifg=#888555
hi pythonException    term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi pythonExClass      term=NONE cterm=NONE ctermbg=bg ctermfg=95 gui=NONE guibg=bg guifg=#996666

hi htmlLink           term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
hi htmlArg            term=NONE cterm=NONE ctermbg=bg ctermfg=103 gui=NONE guibg=bg guifg=#7e8aa2
hi htmlTag            term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi htmlSpecialTagName term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi htmlTagName        term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
hi htmlEndTag         term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#90b0d1
