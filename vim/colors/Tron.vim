" Vim color file
" Converted from Textmate theme Tron using Coloration v0.4.0 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Tron"

hi Cursor ctermfg=16 ctermbg=231 cterm=NONE guifg=#14191f guibg=#f8f8f0 gui=NONE
hi Visual ctermfg=NONE ctermbg=103 cterm=NONE guifg=NONE guibg=#7a9bc2 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#232a32 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#232a32 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#232a32 gui=NONE
hi LineNr ctermfg=60 ctermbg=17 cterm=NONE guifg=#616e80 guibg=#232a32 gui=NONE
hi VertSplit ctermfg=59 ctermbg=59 cterm=NONE guifg=#414a57 guibg=#414a57 gui=NONE
hi MatchParen ctermfg=103 ctermbg=NONE cterm=underline guifg=#748aa6 guibg=NONE gui=underline
hi StatusLine ctermfg=146 ctermbg=59 cterm=bold guifg=#aec2e0 guibg=#414a57 gui=bold
hi StatusLineNC ctermfg=146 ctermbg=59 cterm=NONE guifg=#aec2e0 guibg=#414a57 gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=103 cterm=NONE guifg=NONE guibg=#7a9bc2 gui=NONE
hi IncSearch ctermfg=16 ctermbg=81 cterm=NONE guifg=#14191f guibg=#6ee2ff gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Folded ctermfg=59 ctermbg=16 cterm=NONE guifg=#324357 guibg=#14191f gui=NONE

hi Normal ctermfg=146 ctermbg=16 cterm=NONE guifg=#aec2e0 guibg=#14191f gui=NONE
hi Boolean ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Character ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Comment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#324357 guibg=NONE gui=NONE
hi Conditional ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi DiffAdd ctermfg=146 ctermbg=64 cterm=bold guifg=#aec2e0 guibg=#42800b gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#870506 guibg=NONE gui=NONE
hi DiffChange ctermfg=146 ctermbg=23 cterm=NONE guifg=#aec2e0 guibg=#1a3253 gui=NONE
hi DiffText ctermfg=146 ctermbg=24 cterm=bold guifg=#aec2e0 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=231 ctermbg=38 cterm=NONE guifg=#f8f8f0 guibg=#00a8c6 gui=NONE
hi WarningMsg ctermfg=231 ctermbg=38 cterm=NONE guifg=#f8f8f0 guibg=#00a8c6 gui=NONE
hi Float ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi Function ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi Identifier ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi Keyword ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi Label ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi NonText ctermfg=59 ctermbg=16 cterm=NONE guifg=#3b3a32 guibg=#1c2129 gui=NONE
hi Number ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi Operator ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi PreProc ctermfg=60 ctermbg=NONE cterm=NONE guifg=#4d6785 guibg=NONE gui=NONE
hi Special ctermfg=146 ctermbg=NONE cterm=NONE guifg=#aec2e0 guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=17 cterm=NONE guifg=#3b3a32 guibg=#232a32 gui=NONE
hi Statement ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi StorageClass ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi String ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi Tag ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi Title ctermfg=146 ctermbg=NONE cterm=bold guifg=#aec2e0 guibg=NONE gui=bold
hi Todo ctermfg=59 ctermbg=NONE cterm=inverse,bold guifg=#324357 guibg=NONE gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi rubyFunction ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyConstant ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=italic
hi rubyStringDelimiter ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyInclude ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRegexp ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi rubyEscape ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi rubyControl ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=103 ctermbg=NONE cterm=NONE guifg=#748aa6 guibg=NONE gui=NONE
hi rubyException ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=italic
hi rubyRailsARAssociationMethod ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#324357 guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlAlias ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi cssURL ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi cssFunctionName ctermfg=31 ctermbg=NONE cterm=NONE guifg=#267fb5 guibg=NONE gui=NONE
hi cssColor ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi cssClassName ctermfg=15 ctermbg=NONE cterm=NONE guifg=#ffffff guibg=NONE gui=NONE
hi cssValueLength ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=81 ctermbg=NONE cterm=NONE guifg=#6ee2ff guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE