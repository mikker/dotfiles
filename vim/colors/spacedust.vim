" Vim color file
" Converted from Textmate theme Spacedust using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "spacedust"

hi Cursor ctermfg=16 ctermbg=209 cterm=NONE guifg=#0a171b guibg=#ff8d3d gui=NONE
hi Visual ctermfg=NONE ctermbg=247 cterm=NONE guifg=NONE guibg=#9e9e9e gui=NONE
hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#212d2c gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#212d2c gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#212d2c gui=NONE
hi LineNr ctermfg=59 ctermbg=236 cterm=NONE guifg=#7b846e guibg=#212d2c gui=NONE
hi VertSplit ctermfg=59 ctermbg=59 cterm=NONE guifg=#4c564b guibg=#4c564b gui=NONE
hi MatchParen ctermfg=185 ctermbg=NONE cterm=underline guifg=#ebc562 guibg=NONE gui=underline
hi StatusLine ctermfg=229 ctermbg=59 cterm=bold guifg=#ecf0c1 guibg=#4c564b gui=bold
hi StatusLineNC ctermfg=229 ctermbg=59 cterm=NONE guifg=#ecf0c1 guibg=#4c564b gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=247 cterm=NONE guifg=NONE guibg=#9e9e9e gui=NONE
hi IncSearch ctermfg=16 ctermbg=72 cterm=NONE guifg=#0a171b guibg=#4a9d8f gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi Folded ctermfg=59 ctermbg=16 cterm=NONE guifg=#6e5346 guibg=#0a171b gui=NONE

hi Normal ctermfg=229 ctermbg=234 cterm=NONE guifg=#ecf0c1 guibg=#0a171b gui=NONE
hi Boolean ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi Character ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi Comment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#6e5346 guibg=NONE gui=NONE
hi Conditional ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi DiffAdd ctermfg=229 ctermbg=64 cterm=bold guifg=#ecf0c1 guibg=#40800a gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#850505 guibg=NONE gui=NONE
hi DiffChange ctermfg=229 ctermbg=23 cterm=NONE guifg=#ecf0c1 guibg=#153151 gui=NONE
hi DiffText ctermfg=229 ctermbg=24 cterm=bold guifg=#ecf0c1 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=0 ctermbg=NONE cterm=NONE guifg=#000000 guibg=NONE gui=NONE
hi WarningMsg ctermfg=0 ctermbg=NONE cterm=NONE guifg=#000000 guibg=NONE gui=NONE
hi Float ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi Function ctermfg=38 ctermbg=NONE cterm=NONE guifg=#009fc5 guibg=NONE gui=NONE
hi Identifier ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi Keyword ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi Label ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi NonText ctermfg=236 ctermbg=233 cterm=NONE guifg=#bfbfbf guibg=#152223 gui=NONE
hi Number ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi Operator ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi PreProc ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi Special ctermfg=229 ctermbg=NONE cterm=NONE guifg=#ecf0c1 guibg=NONE gui=NONE
hi SpecialKey ctermfg=250 ctermbg=16 cterm=NONE guifg=#bfbfbf guibg=#212d2c gui=NONE
hi Statement ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi StorageClass ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi String ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
hi Tag ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
hi Title ctermfg=229 ctermbg=NONE cterm=bold guifg=#ecf0c1 guibg=NONE gui=bold
hi Todo ctermfg=59 ctermbg=NONE cterm=inverse,bold guifg=#6e5346 guibg=NONE gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline

" hi rubyClass ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi rubyFunction ctermfg=38 ctermbg=NONE cterm=NONE guifg=#009fc5 guibg=NONE gui=NONE
" hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi rubySymbol ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi rubyConstant ctermfg=166 ctermbg=NONE cterm=NONE guifg=#e35b00 guibg=NONE gui=NONE
" hi rubyStringDelimiter ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi rubyBlockParameter ctermfg=59 ctermbg=NONE cterm=NONE guifg=#305f65 guibg=NONE gui=NONE
" hi rubyInstanceVariable ctermfg=173 ctermbg=NONE cterm=NONE guifg=#cb7636 guibg=NONE gui=NONE
" hi rubyInclude ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi rubyGlobalVariable ctermfg=173 ctermbg=NONE cterm=NONE guifg=#cb7636 guibg=NONE gui=NONE
" hi rubyRegexp ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi rubyRegexpDelimiter ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi rubyEscape ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi rubyControl ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi rubyOperator ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi rubyException ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi rubyPseudoVariable ctermfg=173 ctermbg=NONE cterm=NONE guifg=#cb7636 guibg=NONE gui=NONE
" hi rubyRailsUserClass ctermfg=166 ctermbg=NONE cterm=NONE guifg=#e35b00 guibg=NONE gui=NONE
" hi rubyRailsARAssociationMethod ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi rubyRailsARMethod ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi rubyRailsRenderMethod ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi rubyRailsMethod ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi erubyComment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#6e5346 guibg=NONE gui=NONE
" hi erubyRailsMethod ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi htmlSpecialChar ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi javaScriptFunction ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi javaScriptRailsFunction ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
" hi yamlKey ctermfg=185 ctermbg=NONE cterm=NONE guifg=#ebc562 guibg=NONE gui=NONE
" hi yamlAnchor ctermfg=173 ctermbg=NONE cterm=NONE guifg=#cb7636 guibg=NONE gui=NONE
" hi yamlAlias ctermfg=173 ctermbg=NONE cterm=NONE guifg=#cb7636 guibg=NONE gui=NONE
" hi yamlDocumentHeader ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi cssURL ctermfg=59 ctermbg=NONE cterm=NONE guifg=#305f65 guibg=NONE gui=NONE
" hi cssFunctionName ctermfg=38 ctermbg=NONE cterm=NONE guifg=#039fc5 guibg=NONE gui=NONE
" hi cssColor ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi cssPseudoClassId ctermfg=59 ctermbg=NONE cterm=NONE guifg=#305f65 guibg=NONE gui=NONE
" hi cssClassName ctermfg=59 ctermbg=NONE cterm=NONE guifg=#305f65 guibg=NONE gui=NONE
" hi cssValueLength ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi cssCommonAttr ctermfg=72 ctermbg=NONE cterm=NONE guifg=#4a9d8f guibg=NONE gui=NONE
" hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
