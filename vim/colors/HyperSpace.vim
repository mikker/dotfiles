" Vim color file
" Converted from Textmate theme HyperSpace using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "HyperSpace"

hi Cursor ctermfg=16 ctermbg=248 cterm=NONE guifg=#151823 guibg=#a7a7a7 gui=NONE
hi Visual ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#3d434f gui=NONE
hi CursorLine ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#262a33 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#262a33 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#262a33 gui=NONE
hi LineNr ctermfg=60 ctermbg=17 cterm=NONE guifg=#6c7275 guibg=#262a33 gui=NONE
hi VertSplit ctermfg=59 ctermbg=59 cterm=NONE guifg=#474c53 guibg=#474c53 gui=NONE
hi MatchParen ctermfg=137 ctermbg=NONE cterm=underline guifg=#bc8658 guibg=NONE gui=underline
hi StatusLine ctermfg=251 ctermbg=59 cterm=bold guifg=#c2cbc7 guibg=#474c53 gui=bold
hi StatusLineNC ctermfg=251 ctermbg=59 cterm=NONE guifg=#c2cbc7 guibg=#474c53 gui=NONE
hi Pmenu ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#3d434f gui=NONE
hi IncSearch ctermfg=16 ctermbg=109 cterm=NONE guifg=#151823 guibg=#919fb6 gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi Folded ctermfg=59 ctermbg=16 cterm=NONE guifg=#3a4458 guibg=#151823 gui=NONE

hi Normal ctermfg=251 ctermbg=16 cterm=NONE guifg=#c2cbc7 guibg=#151823 gui=NONE
hi Boolean ctermfg=174 ctermbg=NONE cterm=NONE guifg=#cf8374 guibg=NONE gui=NONE
hi Character ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi Comment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#3a4458 guibg=NONE gui=italic
hi Conditional ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi Constant ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi Define ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi DiffAdd ctermfg=251 ctermbg=64 cterm=bold guifg=#c2cbc7 guibg=#43800c gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#870507 guibg=NONE gui=NONE
hi DiffChange ctermfg=251 ctermbg=23 cterm=NONE guifg=#c2cbc7 guibg=#1a3155 gui=NONE
hi DiffText ctermfg=251 ctermbg=24 cterm=bold guifg=#c2cbc7 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi WarningMsg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Float ctermfg=174 ctermbg=NONE cterm=NONE guifg=#cf8374 guibg=NONE gui=NONE
hi Function ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi Identifier ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi Keyword ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi Label ctermfg=109 ctermbg=16 cterm=NONE guifg=#919fb6 guibg=#151823 gui=NONE
hi NonText ctermfg=59 ctermbg=16 cterm=NONE guifg=#50525a guibg=#1e212b gui=NONE
hi Number ctermfg=174 ctermbg=NONE cterm=NONE guifg=#cf8374 guibg=NONE gui=NONE
hi Operator ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi PreProc ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi Special ctermfg=251 ctermbg=NONE cterm=NONE guifg=#c2cbc7 guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=17 cterm=NONE guifg=#50525a guibg=#262a33 gui=NONE
hi Statement ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi StorageClass ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi String ctermfg=109 ctermbg=16 cterm=NONE guifg=#919fb6 guibg=#151823 gui=NONE
hi Tag ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi Title ctermfg=251 ctermbg=NONE cterm=bold guifg=#c2cbc7 guibg=NONE gui=bold
hi Todo ctermfg=59 ctermbg=NONE cterm=inverse,bold guifg=#3a4458 guibg=NONE gui=inverse,bold,italic
hi Type ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi rubyFunction ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi rubyConstant ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=109 ctermbg=16 cterm=NONE guifg=#919fb6 guibg=#151823 gui=NONE
hi rubyBlockParameter ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyInclude ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyRegexp ctermfg=179 ctermbg=NONE cterm=underline guifg=#e9c062 guibg=NONE gui=underline
hi rubyRegexpDelimiter ctermfg=179 ctermbg=NONE cterm=underline guifg=#e9c062 guibg=NONE gui=underline
hi rubyEscape ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi rubyControl ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyOperator ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi rubyException ctermfg=137 ctermbg=NONE cterm=NONE guifg=#bc8658 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#3a4458 guibg=NONE gui=italic
hi erubyRailsMethod ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi htmlTag ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlEndTag ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlTagName ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlArg ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi yamlAnchor ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi yamlAlias ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=109 ctermbg=16 cterm=NONE guifg=#919fb6 guibg=#151823 gui=NONE
hi cssURL ctermfg=73 ctermbg=NONE cterm=NONE guifg=#6aa1ba guibg=NONE gui=NONE
hi cssFunctionName ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi cssColor ctermfg=108 ctermbg=NONE cterm=NONE guifg=#76a086 guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi cssClassName ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi cssValueLength ctermfg=174 ctermbg=NONE cterm=NONE guifg=#cf8374 guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d0c18d guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE