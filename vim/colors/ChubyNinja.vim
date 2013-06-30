" Vim color file
" Converted from Textmate theme Chuby Ninja using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Chuby Ninja"

hi Cursor ctermfg=235 ctermbg=143 cterm=NONE guifg=#272727 guibg=#bbbb33 gui=NONE
hi Visual ctermfg=NONE ctermbg=22 cterm=NONE guifg=NONE guibg=#2e4d0f gui=NONE
hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3d3d3d gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3d3d3d gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3d3d3d gui=NONE
hi LineNr ctermfg=246 ctermbg=237 cterm=NONE guifg=#939393 guibg=#3d3d3d gui=NONE
hi VertSplit ctermfg=241 ctermbg=241 cterm=NONE guifg=#666666 guibg=#666666 gui=NONE
hi MatchParen ctermfg=114 ctermbg=NONE cterm=underline guifg=#7acc7c guibg=NONE gui=underline
hi StatusLine ctermfg=15 ctermbg=241 cterm=bold guifg=#ffffff guibg=#666666 gui=bold
hi StatusLineNC ctermfg=15 ctermbg=241 cterm=NONE guifg=#ffffff guibg=#666666 gui=NONE
hi Pmenu ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=22 cterm=NONE guifg=NONE guibg=#2e4d0f gui=NONE
hi IncSearch ctermfg=235 ctermbg=210 cterm=NONE guifg=#272727 guibg=#ff9580 gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=114 ctermbg=NONE cterm=NONE guifg=#7acc7c guibg=NONE gui=NONE
hi Folded ctermfg=244 ctermbg=235 cterm=NONE guifg=#808080 guibg=#272727 gui=NONE

hi Normal ctermfg=15 ctermbg=235 cterm=NONE guifg=#ffffff guibg=#272727 gui=NONE
hi Boolean ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi Character ctermfg=114 ctermbg=NONE cterm=NONE guifg=#7acc7c guibg=NONE gui=NONE
hi Comment ctermfg=244 ctermbg=NONE cterm=NONE guifg=#808080 guibg=NONE gui=NONE
hi Conditional ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi Constant ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi Define ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi DiffAdd ctermfg=15 ctermbg=64 cterm=bold guifg=#ffffff guibg=#46830d gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#8b0808 guibg=NONE gui=NONE
hi DiffChange ctermfg=15 ctermbg=23 cterm=NONE guifg=#ffffff guibg=#243957 gui=NONE
hi DiffText ctermfg=15 ctermbg=24 cterm=bold guifg=#ffffff guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=252 ctermbg=52 cterm=NONE guifg=#cccccc guibg=#660000 gui=NONE
hi WarningMsg ctermfg=252 ctermbg=52 cterm=NONE guifg=#cccccc guibg=#660000 gui=NONE
hi Float ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi Function ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi Identifier ctermfg=229 ctermbg=NONE cterm=bold guifg=#ffffb3 guibg=NONE gui=bold
hi Keyword ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi Label ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi NonText ctermfg=59 ctermbg=236 cterm=NONE guifg=#3b3a32 guibg=#323232 gui=NONE
hi Number ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi Operator ctermfg=215 ctermbg=NONE cterm=bold guifg=#ffad59 guibg=NONE gui=bold
hi PreProc ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi Special ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=237 cterm=NONE guifg=#3b3a32 guibg=#3d3d3d gui=NONE
hi Statement ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi StorageClass ctermfg=229 ctermbg=NONE cterm=bold guifg=#ffffb3 guibg=NONE gui=bold
hi String ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi Tag ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi Title ctermfg=15 ctermbg=NONE cterm=bold guifg=#ffffff guibg=NONE gui=bold
hi Todo ctermfg=244 ctermbg=NONE cterm=inverse,bold guifg=#808080 guibg=NONE gui=inverse,bold
hi Type ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi rubyFunction ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=114 ctermbg=NONE cterm=NONE guifg=#7acc7c guibg=NONE gui=NONE
hi rubyConstant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyInclude ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi rubyGlobalVariable ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyRegexp ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi rubyEscape ctermfg=114 ctermbg=NONE cterm=NONE guifg=#7acc7c guibg=NONE gui=NONE
hi rubyControl ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi rubyClassVariable ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyOperator ctermfg=215 ctermbg=NONE cterm=bold guifg=#ffad59 guibg=NONE gui=bold
hi rubyException ctermfg=114 ctermbg=NONE cterm=bold guifg=#7acc7c guibg=NONE gui=bold
hi rubyPseudoVariable ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=244 ctermbg=NONE cterm=NONE guifg=#808080 guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=114 ctermbg=NONE cterm=NONE guifg=#7acc7c guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=229 ctermbg=NONE cterm=bold guifg=#ffffb3 guibg=NONE gui=bold
hi javaScriptRailsFunction ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi yamlAnchor ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi yamlAlias ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi cssURL ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi cssFunctionName ctermfg=123 ctermbg=NONE cterm=NONE guifg=#99feff guibg=NONE gui=NONE
hi cssColor ctermfg=114 ctermbg=NONE cterm=NONE guifg=#7acc7c guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssClassName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssValueLength ctermfg=210 ctermbg=NONE cterm=NONE guifg=#ff9580 guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE