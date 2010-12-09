" Vim color file
" Converted from Textmate theme Summer Camp using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "summercamp"

hi Cursor  guifg=NONE guibg=#f2f8cb gui=NONE
hi Visual  guifg=NONE guibg=#524f47 gui=NONE
hi CursorLine  guifg=NONE guibg=#14120b gui=NONE
hi CursorColumn  guifg=NONE guibg=#14120b gui=NONE
hi LineNr  guifg=#82846a guibg=#110f0a gui=NONE
hi VertSplit  guifg=#3c3b2f guibg=#3c3b2f gui=NONE
hi MatchParen  guifg=#a3ed4e guibg=NONE gui=NONE
hi StatusLine  guifg=#f2f8cb guibg=#3c3b2f gui=bold
hi StatusLineNC  guifg=#f2f8cb guibg=#3c3b2f gui=NONE
hi Pmenu  guifg=NONE guibg=NONE gui=NONE
hi PmenuSel  guifg=NONE guibg=#1e1b12 gui=NONE
hi IncSearch  guifg=NONE guibg=#415820 gui=NONE
hi Search  guifg=NONE guibg=#415820 gui=NONE
hi Directory  guifg=#3a94dc guibg=NONE gui=NONE
hi Folded  guifg=#2b2719 guibg=#110f0a gui=NONE

hi Normal  guifg=#f2f8cb guibg=#2e2b24 gui=NONE
hi Boolean  guifg=#3588ca guibg=NONE gui=NONE
hi Character  guifg=#3a94dc guibg=NONE gui=NONE
hi Comment  guifg=#555555 guibg=NONE gui=italic
hi Conditional  guifg=#a3ed4e guibg=NONE gui=NONE
hi Constant  guifg=#3a94dc guibg=NONE gui=NONE
hi Define  guifg=#a3ed4e guibg=NONE gui=NONE
hi ErrorMsg  guifg=NONE guibg=#f32119 gui=italic
hi WarningMsg  guifg=NONE guibg=#f32119 gui=italic
hi Float  guifg=#3fa2ed guibg=NONE gui=NONE
hi Function  guifg=#7dde12 guibg=NONE gui=NONE
hi Identifier  guifg=#a3ed4e guibg=NONE gui=NONE
hi Keyword  guifg=#a3ed4e guibg=NONE gui=NONE
hi Label  guifg=#f39b19 guibg=NONE gui=NONE
hi NonText  guifg=#f3771d guibg=#14120b gui=NONE
hi Number  guifg=#3fa2ed guibg=NONE gui=NONE
hi Operator  guifg=#a3ed4e guibg=NONE gui=NONE
hi PreProc  guifg=#a3ed4e guibg=NONE gui=NONE
hi Special  guifg=#f2f8cb guibg=NONE gui=NONE
hi SpecialKey  guifg=#f3771d guibg=#14120b gui=NONE
hi Statement  guifg=#a3ed4e guibg=NONE gui=NONE
hi StorageClass  guifg=#a3ed4e guibg=NONE gui=NONE
hi String  guifg=#f39b19 guibg=NONE gui=NONE
hi Tag  guifg=NONE guibg=NONE gui=NONE
hi Title  guifg=#f2f8cb guibg=NONE gui=bold
hi Todo  guifg=#2b2719 guibg=#16140d gui=inverse,bold,italic
hi Type  guifg=#eef890 guibg=NONE gui=italic
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#a3ed4e guibg=NONE gui=NONE
hi rubyFunction  guifg=#7dde12 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=#3a94dc guibg=NONE gui=NONE
hi rubyConstant  guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#f39b19 guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=NONE guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=#f35e18 guibg=NONE gui=NONE
hi rubyInclude  guifg=#a3ed4e guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=#f35e18 guibg=NONE gui=NONE
hi rubyRegexp  guifg=#f39b19 guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#f39b19 guibg=NONE gui=NONE
hi rubyEscape  guifg=#f3771d guibg=NONE gui=NONE
hi rubyControl  guifg=#a3ed4e guibg=NONE gui=NONE
hi rubyClassVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyOperator  guifg=#a3ed4e guibg=NONE gui=NONE
hi rubyException  guifg=#a3ed4e guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=#f35e18 guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=NONE guibg=NONE gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#2b2719 guibg=#16140d gui=italic
hi erubyRailsMethod  guifg=NONE guibg=NONE gui=NONE
hi htmlTag  guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag  guifg=NONE guibg=NONE gui=NONE
hi htmlTagName  guifg=NONE guibg=NONE gui=NONE
hi htmlArg  guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#3a94dc guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#a3ed4e guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=NONE guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=NONE guibg=NONE gui=NONE
hi yamlAnchor  guifg=#f35e18 guibg=NONE gui=NONE
hi yamlAlias  guifg=#f35e18 guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#f39b19 guibg=NONE gui=NONE
hi cssURL  guifg=NONE guibg=NONE gui=NONE
hi cssFunctionName  guifg=NONE guibg=NONE gui=NONE
hi cssColor  guifg=#3a94dc guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=NONE guibg=NONE gui=NONE
hi cssClassName  guifg=NONE guibg=NONE gui=NONE
hi cssValueLength  guifg=#3fa2ed guibg=NONE gui=NONE
hi cssCommonAttr  guifg=NONE guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
