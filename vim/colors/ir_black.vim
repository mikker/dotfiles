" Vim color file
" Converted from Textmate theme IR_Black using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "ir_black"

hi Cursor  guifg=NONE guibg=#ffffff gui=NONE
hi Visual  guifg=NONE guibg=#333333 gui=NONE
hi CursorLine  guifg=NONE guibg=#242424 gui=NONE
hi CursorColumn  guifg=NONE guibg=#242424 gui=NONE
hi LineNr  guifg=#777777 guibg=#000000 gui=NONE
hi VertSplit  guifg=#2d2d2d guibg=#2d2d2d gui=NONE
hi MatchParen  guifg=#96cbfe guibg=NONE gui=NONE
hi StatusLine  guifg=#ededed guibg=#2d2d2d gui=bold
hi StatusLineNC  guifg=#ededed guibg=#2d2d2d gui=NONE
hi Pmenu  guifg=#ffd2a7 guibg=NONE gui=NONE
hi PmenuSel  guifg=NONE guibg=#333333 gui=NONE
hi IncSearch  guifg=NONE guibg=#414154 gui=NONE
hi Search  guifg=NONE guibg=#414154 gui=NONE
hi Directory  guifg=#99cc99 guibg=NONE gui=NONE
hi Folded  guifg=#7c7c7c guibg=#000000 gui=NONE

hi Normal  guifg=#ededed guibg=#000000 gui=NONE
hi Boolean  guifg=#99cc99 guibg=NONE gui=NONE
hi Character  guifg=#99cc99 guibg=NONE gui=NONE
hi Comment  guifg=#7c7c7c guibg=NONE gui=NONE
hi Conditional  guifg=#96cbfe guibg=NONE gui=NONE
hi Constant  guifg=#99cc99 guibg=NONE gui=NONE
hi Define  guifg=#96cbfe guibg=NONE gui=NONE
hi ErrorMsg  guifg=NONE guibg=NONE gui=NONE
hi WarningMsg  guifg=NONE guibg=NONE gui=NONE
hi Float  guifg=#ff73fd guibg=NONE gui=bold
hi Function  guifg=#ffd2a7 guibg=NONE gui=NONE
hi Identifier  guifg=#cfcb90 guibg=NONE gui=NONE
hi Keyword  guifg=#96cbfe guibg=NONE gui=NONE
hi Label  guifg=#a8ff60 guibg=NONE gui=bold
hi NonText  guifg=#2e343a guibg=#242424 gui=NONE
hi Number  guifg=#ff73fd guibg=NONE gui=bold
hi Operator  guifg=#ededed guibg=NONE gui=NONE
hi PreProc  guifg=#96cbfe guibg=NONE gui=NONE
hi Special  guifg=#ededed guibg=NONE gui=NONE
hi SpecialKey  guifg=#2e343a guibg=#242424 gui=NONE
hi Statement  guifg=#96cbfe guibg=NONE gui=NONE
hi StorageClass  guifg=#cfcb90 guibg=NONE gui=NONE
hi String  guifg=#a8ff60 guibg=NONE gui=bold
hi Tag  guifg=#ffd2a7 guibg=NONE gui=NONE
hi Title  guifg=#ededed guibg=NONE gui=bold
hi Todo  guifg=#7c7c7c guibg=NONE gui=inverse,bold
hi Type  guifg=#ffffb6 guibg=NONE gui=underline
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#96cbfe guibg=NONE gui=NONE
hi rubyFunction  guifg=#ffd2a7 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=#99cc99 guibg=NONE gui=NONE
hi rubyConstant  guifg=#ffffb6 guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#a8ff60 guibg=NONE gui=bold
hi rubyBlockParameter  guifg=#c6c5fe guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=#c6c5fe guibg=NONE gui=NONE
hi rubyInclude  guifg=#96cbfe guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=#c6c5fe guibg=NONE gui=NONE
hi rubyRegexp  guifg=#e9c062 guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#e9c062 guibg=NONE gui=NONE
hi rubyEscape  guifg=#99cc99 guibg=NONE gui=NONE
hi rubyControl  guifg=#96cbfe guibg=NONE gui=NONE
hi rubyClassVariable  guifg=#c6c5fe guibg=NONE gui=NONE
hi rubyOperator  guifg=#ededed guibg=NONE gui=NONE
hi rubyException  guifg=#96cbfe guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=#c6c5fe guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=#ffffb6 guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=#dad085 guibg=NONE gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#7c7c7c guibg=NONE gui=NONE
hi erubyRailsMethod  guifg=#dad085 guibg=NONE gui=NONE
hi htmlTag  guifg=#96cbfe guibg=NONE gui=bold
hi htmlEndTag  guifg=#96cbfe guibg=NONE gui=bold
hi htmlTagName  guifg=#96cbfe guibg=NONE gui=bold
hi htmlArg  guifg=#96cbfe guibg=NONE gui=bold
hi htmlSpecialChar  guifg=#99cc99 guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#cfcb90 guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=#dad085 guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#ffd2a7 guibg=NONE gui=NONE
hi yamlAnchor  guifg=#c6c5fe guibg=NONE gui=NONE
hi yamlAlias  guifg=#c6c5fe guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#a8ff60 guibg=NONE gui=bold
hi cssURL  guifg=#c6c5fe guibg=NONE gui=NONE
hi cssFunctionName  guifg=#dad085 guibg=NONE gui=NONE
hi cssColor  guifg=#99cc99 guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=#ffd7b1 guibg=NONE gui=NONE
hi cssClassName  guifg=#ffd7b1 guibg=NONE gui=NONE
hi cssValueLength  guifg=#ff73fd guibg=NONE gui=bold
hi cssCommonAttr  guifg=#ffd2a7 guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
