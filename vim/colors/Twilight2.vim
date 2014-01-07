" Vim color file
" Converted from Textmate theme Twilight2 using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Twilight2"

hi Cursor ctermfg=16 ctermbg=197 cterm=NONE guifg=#1b1611 guibg=#ff2f54 gui=NONE
hi Visual ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#4f3a4d gui=NONE
hi CursorLine ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#302c23 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#302c23 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=16 cterm=NONE guifg=NONE guibg=#302c23 gui=NONE
hi LineNr ctermfg=101 ctermbg=16 cterm=NONE guifg=#83836c guibg=#302c23 gui=NONE
hi VertSplit ctermfg=59 ctermbg=59 cterm=NONE guifg=#575545 guibg=#575545 gui=NONE
hi MatchParen ctermfg=169 ctermbg=NONE cterm=underline guifg=#cd4ab1 guibg=NONE gui=underline
hi StatusLine ctermfg=194 ctermbg=59 cterm=bold guifg=#ebf0c6 guibg=#575545 gui=bold
hi StatusLineNC ctermfg=194 ctermbg=59 cterm=NONE guifg=#ebf0c6 guibg=#575545 gui=NONE
hi Pmenu ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#4f3a4d gui=NONE
hi IncSearch ctermfg=16 ctermbg=150 cterm=NONE guifg=#1b1611 guibg=#b5c886 gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi Folded ctermfg=59 ctermbg=16 cterm=NONE guifg=#413a33 guibg=#1b1611 gui=NONE

hi Normal ctermfg=194 ctermbg=16 cterm=NONE guifg=#ebf0c6 guibg=#1b1611 gui=NONE
hi Boolean ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi Character ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi Comment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#413a33 guibg=NONE gui=italic
hi Conditional ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi Constant ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi Define ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi DiffAdd ctermfg=194 ctermbg=64 cterm=bold guifg=#ebf0c6 guibg=#448008 gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#890403 guibg=NONE gui=NONE
hi DiffChange ctermfg=194 ctermbg=23 cterm=NONE guifg=#ebf0c6 guibg=#1e304c gui=NONE
hi DiffText ctermfg=194 ctermbg=24 cterm=bold guifg=#ebf0c6 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi WarningMsg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Float ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi Function ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi Identifier ctermfg=228 ctermbg=NONE cterm=NONE guifg=#f9ee98 guibg=NONE gui=NONE
hi Keyword ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi Label ctermfg=150 ctermbg=NONE cterm=NONE guifg=#b5c886 guibg=NONE gui=NONE
hi NonText ctermfg=59 ctermbg=16 cterm=NONE guifg=#54504d guibg=#25211a gui=NONE
hi Number ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi Operator ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi PreProc ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi Special ctermfg=194 ctermbg=NONE cterm=NONE guifg=#ebf0c6 guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=16 cterm=NONE guifg=#54504d guibg=#302c23 gui=NONE
hi Statement ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi StorageClass ctermfg=228 ctermbg=NONE cterm=NONE guifg=#f9ee98 guibg=NONE gui=NONE
hi String ctermfg=150 ctermbg=NONE cterm=NONE guifg=#b5c886 guibg=NONE gui=NONE
hi Tag ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi Title ctermfg=194 ctermbg=NONE cterm=bold guifg=#ebf0c6 guibg=NONE gui=bold
hi Todo ctermfg=59 ctermbg=NONE cterm=inverse,bold guifg=#413a33 guibg=NONE gui=inverse,bold,italic
hi Type ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi rubyFunction ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi rubyConstant ctermfg=103 ctermbg=NONE cterm=NONE guifg=#9b859d guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=150 ctermbg=NONE cterm=NONE guifg=#b5c886 guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi rubyInclude ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi rubyRegexp ctermfg=179 ctermbg=NONE cterm=NONE guifg=#e9c062 guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=179 ctermbg=NONE cterm=NONE guifg=#e9c062 guibg=NONE gui=NONE
hi rubyEscape ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi rubyControl ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi rubyOperator ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi rubyException ctermfg=169 ctermbg=NONE cterm=NONE guifg=#cd4ab1 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=103 ctermbg=NONE cterm=NONE guifg=#9b859d guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#413a33 guibg=NONE gui=italic
hi erubyRailsMethod ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi htmlTag ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlEndTag ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlTagName ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlArg ctermfg=137 ctermbg=NONE cterm=NONE guifg=#ac885b guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=228 ctermbg=NONE cterm=NONE guifg=#f9ee98 guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi yamlAnchor ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi yamlAlias ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=150 ctermbg=NONE cterm=NONE guifg=#b5c886 guibg=NONE gui=NONE
hi cssURL ctermfg=103 ctermbg=NONE cterm=NONE guifg=#7587a6 guibg=NONE gui=NONE
hi cssFunctionName ctermfg=186 ctermbg=NONE cterm=NONE guifg=#dad085 guibg=NONE gui=NONE
hi cssColor ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi cssClassName ctermfg=95 ctermbg=NONE cterm=NONE guifg=#9b703f guibg=NONE gui=NONE
hi cssValueLength ctermfg=73 ctermbg=NONE cterm=NONE guifg=#67b3b6 guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=167 ctermbg=NONE cterm=NONE guifg=#cf6a4c guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE