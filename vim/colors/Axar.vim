" Vim color file
" Converted from Textmate theme Axar using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Axar"

hi Cursor ctermfg=234 ctermbg=15 cterm=NONE guifg=#191919 guibg=#ffffff gui=NONE
hi Visual ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#393939 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#303030 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#303030 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#303030 gui=NONE
hi LineNr ctermfg=245 ctermbg=236 cterm=NONE guifg=#8c8c8c guibg=#303030 gui=NONE
hi VertSplit ctermfg=240 ctermbg=240 cterm=NONE guifg=#5c5c5c guibg=#5c5c5c gui=NONE
hi MatchParen ctermfg=15 ctermbg=NONE cterm=underline guifg=#ffffff guibg=NONE gui=underline
hi StatusLine ctermfg=15 ctermbg=240 cterm=bold guifg=#ffffff guibg=#5c5c5c gui=bold
hi StatusLineNC ctermfg=15 ctermbg=240 cterm=NONE guifg=#ffffff guibg=#5c5c5c gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#393939 gui=NONE
hi IncSearch ctermfg=234 ctermbg=220 cterm=NONE guifg=#191919 guibg=#ffd700 gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66ccff guibg=NONE gui=NONE
hi Folded ctermfg=210 ctermbg=234 cterm=NONE guifg=#ff7777 guibg=#191919 gui=NONE

hi Normal ctermfg=15 ctermbg=234 cterm=NONE guifg=#ffffff guibg=#191919 gui=NONE
hi Boolean ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi Character ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Comment ctermfg=210 ctermbg=233 cterm=NONE guifg=#ff7777 guibg=#171717 gui=NONE
hi Conditional ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi DiffAdd ctermfg=15 ctermbg=64 cterm=bold guifg=#ffffff guibg=#43800a gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#880505 guibg=NONE gui=NONE
hi DiffChange ctermfg=15 ctermbg=23 cterm=NONE guifg=#ffffff guibg=#1c3250 gui=NONE
hi DiffText ctermfg=15 ctermbg=24 cterm=bold guifg=#ffffff guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=NONE ctermbg=52 cterm=bold guifg=NONE guibg=#670000 gui=bold
hi WarningMsg ctermfg=NONE ctermbg=52 cterm=bold guifg=NONE guibg=#670000 gui=bold
hi Float ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eddd5a guibg=NONE gui=NONE
hi Function ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Identifier ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi Keyword ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Label ctermfg=220 ctermbg=NONE cterm=NONE guifg=#ffd700 guibg=NONE gui=NONE
hi NonText ctermfg=238 ctermbg=235 cterm=NONE guifg=#404040 guibg=#252525 gui=NONE
hi Number ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eddd5a guibg=NONE gui=NONE
hi Operator ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi PreProc ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Special ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi SpecialKey ctermfg=238 ctermbg=236 cterm=NONE guifg=#404040 guibg=#303030 gui=NONE
hi Statement ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi StorageClass ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi String ctermfg=220 ctermbg=NONE cterm=NONE guifg=#ffd700 guibg=NONE gui=NONE
hi Tag ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi Title ctermfg=15 ctermbg=NONE cterm=bold guifg=#ffffff guibg=NONE gui=bold
hi Todo ctermfg=210 ctermbg=233 cterm=inverse,bold guifg=#ff7777 guibg=#171717 gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi rubyFunction ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66ccff guibg=NONE gui=NONE
hi rubyConstant ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=220 ctermbg=NONE cterm=NONE guifg=#ffd700 guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=italic
hi rubyInstanceVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyInclude ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRegexp ctermfg=167 ctermbg=NONE cterm=NONE guifg=#ca4344 guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=167 ctermbg=NONE cterm=NONE guifg=#ca4344 guibg=NONE gui=NONE
hi rubyEscape ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyControl ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyException ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=210 ctermbg=233 cterm=NONE guifg=#ff7777 guibg=#171717 gui=NONE
hi erubyRailsMethod ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=112 ctermbg=NONE cterm=NONE guifg=#80d500 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlAlias ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=220 ctermbg=NONE cterm=NONE guifg=#ffd700 guibg=NONE gui=NONE
hi cssURL ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=italic
hi cssFunctionName ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi cssColor ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66ccff guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=131 ctermbg=NONE cterm=bold guifg=#b53b3c guibg=NONE gui=bold
hi cssClassName ctermfg=131 ctermbg=NONE cterm=bold guifg=#b53b3c guibg=NONE gui=bold
hi cssValueLength ctermfg=221 ctermbg=NONE cterm=NONE guifg=#eddd5a guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=109 ctermbg=NONE cterm=NONE guifg=#8aa6c1 guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE