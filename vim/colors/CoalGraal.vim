" Vim color file
" Converted from Textmate theme Coal Graal using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Coal Graal"

hi Cursor ctermfg=235 ctermbg=188 cterm=NONE guifg=#222222 guibg=#d8d9d1 gui=NONE
hi Visual ctermfg=NONE ctermbg=56 cterm=NONE guifg=NONE guibg=#6405d0 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#343433 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#343433 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#343433 gui=NONE
hi LineNr ctermfg=102 ctermbg=236 cterm=NONE guifg=#7d7e7a guibg=#343433 gui=NONE
hi VertSplit ctermfg=240 ctermbg=240 cterm=NONE guifg=#575755 guibg=#575755 gui=NONE
hi MatchParen ctermfg=146 ctermbg=NONE cterm=underline guifg=#a3aad8 guibg=NONE gui=underline
hi StatusLine ctermfg=188 ctermbg=240 cterm=bold guifg=#d8d9d1 guibg=#575755 gui=bold
hi StatusLineNC ctermfg=188 ctermbg=240 cterm=NONE guifg=#d8d9d1 guibg=#575755 gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=56 cterm=NONE guifg=NONE guibg=#6405d0 gui=NONE
hi IncSearch ctermfg=235 ctermbg=152 cterm=NONE guifg=#222222 guibg=#acc6d7 gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=185 ctermbg=NONE cterm=NONE guifg=#dfca53 guibg=NONE gui=NONE
hi Folded ctermfg=149 ctermbg=235 cterm=NONE guifg=#b4df61 guibg=#222222 gui=NONE

hi Normal ctermfg=188 ctermbg=235 cterm=NONE guifg=#d8d9d1 guibg=#222222 gui=NONE
hi Boolean ctermfg=215 ctermbg=NONE cterm=NONE guifg=#edb272 guibg=NONE gui=NONE
hi Character ctermfg=185 ctermbg=NONE cterm=NONE guifg=#dfca53 guibg=NONE gui=NONE
hi Comment ctermfg=149 ctermbg=NONE cterm=NONE guifg=#b4df61 guibg=NONE gui=NONE
hi Conditional ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi DiffAdd ctermfg=188 ctermbg=64 cterm=bold guifg=#d8d9d1 guibg=#45820c gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#8a0707 guibg=NONE gui=NONE
hi DiffChange ctermfg=188 ctermbg=23 cterm=NONE guifg=#d8d9d1 guibg=#213655 gui=NONE
hi DiffText ctermfg=188 ctermbg=24 cterm=bold guifg=#d8d9d1 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=188 ctermbg=160 cterm=NONE guifg=#dfdfd5 guibg=#cc1b27 gui=NONE
hi WarningMsg ctermfg=188 ctermbg=160 cterm=NONE guifg=#dfdfd5 guibg=#cc1b27 gui=NONE
hi Float ctermfg=185 ctermbg=NONE cterm=NONE guifg=#e4d962 guibg=NONE gui=NONE
hi Function ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dfcc94 guibg=NONE gui=NONE
hi Identifier ctermfg=183 ctermbg=NONE cterm=NONE guifg=#dbbfed guibg=NONE gui=NONE
hi Keyword ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi Label ctermfg=152 ctermbg=NONE cterm=NONE guifg=#acc6d7 guibg=NONE gui=NONE
hi NonText ctermfg=187 ctermbg=235 cterm=NONE guifg=#e5e5b2 guibg=#2b2b2b gui=NONE
hi Number ctermfg=185 ctermbg=NONE cterm=NONE guifg=#e4d962 guibg=NONE gui=NONE
hi Operator ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi PreProc ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi Special ctermfg=188 ctermbg=NONE cterm=NONE guifg=#d8d9d1 guibg=NONE gui=NONE
hi SpecialKey ctermfg=187 ctermbg=236 cterm=NONE guifg=#e5e5b2 guibg=#343433 gui=NONE
hi Statement ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi StorageClass ctermfg=183 ctermbg=NONE cterm=NONE guifg=#dbbfed guibg=NONE gui=NONE
hi String ctermfg=152 ctermbg=NONE cterm=NONE guifg=#acc6d7 guibg=NONE gui=NONE
hi Tag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Title ctermfg=188 ctermbg=NONE cterm=bold guifg=#d8d9d1 guibg=NONE gui=bold
hi Todo ctermfg=149 ctermbg=NONE cterm=inverse,bold guifg=#b4df61 guibg=NONE gui=inverse,bold
hi Type ctermfg=140 ctermbg=NONE cterm=NONE guifg=#b998df guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi rubyFunction ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dfcc94 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=185 ctermbg=NONE cterm=NONE guifg=#dfca53 guibg=NONE gui=NONE
hi rubyConstant ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a9a5d9 guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=152 ctermbg=NONE cterm=NONE guifg=#acc6d7 guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=116 ctermbg=NONE cterm=NONE guifg=#85c6d9 guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=111 ctermbg=NONE cterm=NONE guifg=#7ac0ed guibg=NONE gui=NONE
hi rubyInclude ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=111 ctermbg=NONE cterm=NONE guifg=#7ac0ed guibg=NONE gui=NONE
hi rubyRegexp ctermfg=152 ctermbg=NONE cterm=NONE guifg=#acc6d7 guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=152 ctermbg=NONE cterm=NONE guifg=#acc6d7 guibg=NONE gui=NONE
hi rubyEscape ctermfg=185 ctermbg=NONE cterm=NONE guifg=#dfca53 guibg=NONE gui=NONE
hi rubyControl ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi rubyException ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a3aad8 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=111 ctermbg=NONE cterm=NONE guifg=#7ac0ed guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=146 ctermbg=NONE cterm=NONE guifg=#a9a5d9 guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=149 ctermbg=NONE cterm=NONE guifg=#b4df61 guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=185 ctermbg=NONE cterm=NONE guifg=#dfca53 guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=183 ctermbg=NONE cterm=NONE guifg=#dbbfed guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlAnchor ctermfg=111 ctermbg=NONE cterm=NONE guifg=#7ac0ed guibg=NONE gui=NONE
hi yamlAlias ctermfg=111 ctermbg=NONE cterm=NONE guifg=#7ac0ed guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=152 ctermbg=NONE cterm=NONE guifg=#acc6d7 guibg=NONE gui=NONE
hi cssURL ctermfg=116 ctermbg=NONE cterm=NONE guifg=#85c6d9 guibg=NONE gui=NONE
hi cssFunctionName ctermfg=186 ctermbg=NONE cterm=NONE guifg=#d9c589 guibg=NONE gui=NONE
hi cssColor ctermfg=185 ctermbg=NONE cterm=NONE guifg=#dfca53 guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssClassName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssValueLength ctermfg=185 ctermbg=NONE cterm=NONE guifg=#e4d962 guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE