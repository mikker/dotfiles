" Vim color file
" Converted from Textmate theme Happydeluxe using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "happydeluxe"

hi Cursor  guifg=NONE guibg=#ffffff gui=NONE
hi Visual  guifg=NONE guibg=#15285a gui=NONE
hi CursorLine  guifg=NONE guibg=#070a10 gui=NONE
hi CursorColumn  guifg=NONE guibg=#070a10 gui=NONE
hi LineNr  guifg=#87898f guibg=#0e131e gui=NONE
hi VertSplit  guifg=#3c4049 guibg=#3c4049 gui=NONE
hi MatchParen  guifg=#fe9006 guibg=NONE gui=NONE
hi StatusLine  guifg=#ffffff guibg=#3c4049 gui=bold
hi StatusLineNC  guifg=#ffffff guibg=#3c4049 gui=NONE
hi Pmenu  guifg=NONE guibg=NONE gui=NONE
hi PmenuSel  guifg=NONE guibg=#15285a gui=NONE
hi IncSearch  guifg=NONE guibg=#5d3c16 gui=NONE
hi Search  guifg=NONE guibg=#5d3c16 gui=NONE
hi Directory  guifg=NONE guibg=NONE gui=NONE
hi Folded  guifg=#35497c guibg=#0e131e gui=NONE

hi Normal  guifg=#ffffff guibg=#0e131e gui=NONE
hi Boolean  guifg=#14ded1 guibg=NONE gui=NONE
hi Character  guifg=NONE guibg=NONE gui=NONE
hi Comment  guifg=#35497c guibg=NONE gui=NONE
hi Conditional  guifg=#fe9006 guibg=NONE gui=NONE
hi Constant  guifg=NONE guibg=NONE gui=NONE
hi Define  guifg=#fe9006 guibg=NONE gui=NONE
hi ErrorMsg  guifg=#fc2d07 guibg=NONE gui=NONE
hi WarningMsg  guifg=#fc2d07 guibg=NONE gui=NONE
hi Float  guifg=NONE guibg=NONE gui=NONE
hi Function  guifg=NONE guibg=NONE gui=NONE
hi Identifier  guifg=#fe9006 guibg=NONE gui=NONE
hi Keyword  guifg=#fe9006 guibg=NONE gui=NONE
hi Label  guifg=#fd66f9 guibg=NONE gui=NONE
hi NonText  guifg=#646871 guibg=#070a10 gui=NONE
hi Number  guifg=NONE guibg=NONE gui=NONE
hi Operator  guifg=#fe9006 guibg=NONE gui=NONE
hi PreProc  guifg=#fe9006 guibg=NONE gui=NONE
hi Special  guifg=#ffffff guibg=NONE gui=NONE
hi SpecialKey  guifg=#646871 guibg=#070a10 gui=NONE
hi Statement  guifg=#fe9006 guibg=NONE gui=NONE
hi StorageClass  guifg=#fe9006 guibg=NONE gui=NONE
hi String  guifg=#fd66f9 guibg=NONE gui=NONE
hi Tag  guifg=#14ded1 guibg=NONE gui=NONE
hi Title  guifg=#ffffff guibg=NONE gui=bold
hi Todo  guifg=#35497c guibg=NONE gui=inverse,bold
hi Type  guifg=NONE guibg=NONE gui=NONE
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#fe9006 guibg=NONE gui=NONE
hi rubyFunction  guifg=NONE guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=NONE guibg=NONE gui=NONE
hi rubyConstant  guifg=#14ded1 guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#fd66f9 guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=NONE guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=#ffffff guibg=NONE gui=NONE
hi rubyInclude  guifg=#fe9006 guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=#ffffff guibg=NONE gui=NONE
hi rubyRegexp  guifg=#fd66f9 guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#fd66f9 guibg=NONE gui=NONE
hi rubyEscape  guifg=NONE guibg=NONE gui=NONE
hi rubyControl  guifg=#fe9006 guibg=NONE gui=NONE
hi rubyClassVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyOperator  guifg=#fe9006 guibg=NONE gui=NONE
hi rubyException  guifg=#fe9006 guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=#ffffff guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=#14ded1 guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=#14ded1 guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=#14ded1 guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=#14ded1 guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=#14ded1 guibg=NONE gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#35497c guibg=NONE gui=NONE
hi erubyRailsMethod  guifg=#14ded1 guibg=NONE gui=NONE
hi htmlTag  guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag  guifg=NONE guibg=NONE gui=NONE
hi htmlTagName  guifg=NONE guibg=NONE gui=NONE
hi htmlArg  guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=NONE guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#fe9006 guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=#14ded1 guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#14ded1 guibg=NONE gui=NONE
hi yamlAnchor  guifg=#ffffff guibg=NONE gui=NONE
hi yamlAlias  guifg=#ffffff guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#fd66f9 guibg=NONE gui=NONE
hi cssURL  guifg=NONE guibg=NONE gui=NONE
hi cssFunctionName  guifg=#14ded1 guibg=NONE gui=NONE
hi cssColor  guifg=NONE guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=NONE guibg=NONE gui=NONE
hi cssClassName  guifg=NONE guibg=NONE gui=NONE
hi cssValueLength  guifg=NONE guibg=NONE gui=NONE
hi cssCommonAttr  guifg=#14ded1 guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
