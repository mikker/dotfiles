" Vim color file
" Converted from Textmate theme Slush & Poppies using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "slush_poppies"

hi Cursor  guifg=NONE guibg=#000000 gui=NONE
hi Visual  guifg=NONE guibg=#b0b0ff gui=NONE
hi CursorLine  guifg=NONE guibg=#d1d1d1 gui=NONE
hi CursorColumn  guifg=NONE guibg=#d1d1d1 gui=NONE
hi LineNr  guifg=#7a7a7a guibg=#f3f3f3 gui=NONE
hi VertSplit  guifg=#c5c5c5 guibg=#c5c5c5 gui=NONE
hi MatchParen  guifg=#2060a0 guibg=NONE gui=NONE
hi StatusLine  guifg=#000000 guibg=#c5c5c5 gui=bold
hi StatusLineNC  guifg=#000000 guibg=#c5c5c5 gui=NONE
hi Pmenu  guifg=NONE guibg=NONE gui=NONE
hi PmenuSel  guifg=NONE guibg=#b0b0ff gui=NONE
hi IncSearch  guifg=NONE guibg=#adc2d8 gui=NONE
hi Search  guifg=NONE guibg=#adc2d8 gui=NONE
hi Directory  guifg=NONE guibg=NONE gui=NONE
hi Folded  guifg=#406040 guibg=#f3f3f3 gui=NONE

hi Normal  guifg=#000000 guibg=#f3f3f3 gui=NONE
hi Boolean  guifg=NONE guibg=NONE gui=NONE
hi Character  guifg=#800000 guibg=NONE gui=NONE
hi Comment  guifg=#406040 guibg=NONE gui=NONE
hi Conditional  guifg=#2060a0 guibg=NONE gui=NONE
hi Constant  guifg=NONE guibg=NONE gui=NONE
hi Define  guifg=#2060a0 guibg=NONE gui=NONE
hi ErrorMsg  guifg=NONE guibg=NONE gui=NONE
hi WarningMsg  guifg=NONE guibg=NONE gui=NONE
hi Float  guifg=#0080a0 guibg=NONE gui=NONE
hi Function  guifg=#800000 guibg=NONE gui=NONE
hi Identifier  guifg=#a08000 guibg=NONE gui=NONE
hi Keyword  guifg=#2060a0 guibg=NONE gui=NONE
hi Label  guifg=#c03030 guibg=NONE gui=NONE
hi NonText  guifg=#bfbfbf guibg=#d1d1d1 gui=NONE
hi Number  guifg=#0080a0 guibg=NONE gui=NONE
hi Operator  guifg=#2060a0 guibg=NONE gui=NONE
hi PreProc  guifg=#2060a0 guibg=NONE gui=NONE
hi Special  guifg=#000000 guibg=NONE gui=NONE
hi SpecialKey  guifg=#bfbfbf guibg=#d1d1d1 gui=NONE
hi Statement  guifg=#2060a0 guibg=NONE gui=NONE
hi StorageClass  guifg=#a08000 guibg=NONE gui=NONE
hi String  guifg=#c03030 guibg=NONE gui=NONE
hi Tag  guifg=NONE guibg=NONE gui=NONE
hi Title  guifg=#000000 guibg=NONE gui=bold
hi Todo  guifg=#406040 guibg=NONE gui=inverse,bold
hi Type  guifg=NONE guibg=NONE gui=NONE
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#2060a0 guibg=NONE gui=NONE
hi rubyFunction  guifg=#800000 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=NONE guibg=NONE gui=NONE
hi rubyConstant  guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#c03030 guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=NONE guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyInclude  guifg=#2060a0 guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyRegexp  guifg=#c03030 guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#c03030 guibg=NONE gui=NONE
hi rubyEscape  guifg=#800000 guibg=NONE gui=NONE
hi rubyControl  guifg=#2060a0 guibg=NONE gui=NONE
hi rubyClassVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyOperator  guifg=#2060a0 guibg=NONE gui=NONE
hi rubyException  guifg=#2060a0 guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=NONE guibg=NONE gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#406040 guibg=NONE gui=NONE
hi erubyRailsMethod  guifg=NONE guibg=NONE gui=NONE
hi htmlTag  guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag  guifg=NONE guibg=NONE gui=NONE
hi htmlTagName  guifg=NONE guibg=NONE gui=NONE
hi htmlArg  guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#800000 guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#a08000 guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=NONE guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=NONE guibg=NONE gui=NONE
hi yamlAnchor  guifg=NONE guibg=NONE gui=NONE
hi yamlAlias  guifg=NONE guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#c03030 guibg=NONE gui=NONE
hi cssURL  guifg=NONE guibg=NONE gui=NONE
hi cssFunctionName  guifg=NONE guibg=NONE gui=NONE
hi cssColor  guifg=NONE guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=NONE guibg=NONE gui=NONE
hi cssClassName  guifg=NONE guibg=NONE gui=NONE
hi cssValueLength  guifg=#0080a0 guibg=NONE gui=NONE
hi cssCommonAttr  guifg=NONE guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
