" Vim color file
" Converted from Textmate theme eclips3.media (ECLM) using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "eclips3"

hi Cursor  guifg=NONE guibg=#ffffff gui=NONE
hi Visual  guifg=NONE guibg=#545d73 gui=NONE
hi CursorLine  guifg=NONE guibg=#393a3c gui=NONE
hi CursorColumn  guifg=NONE guibg=#393a3c gui=NONE
hi LineNr  guifg=#898685 guibg=#2b2b2b gui=NONE
hi VertSplit  guifg=#4f4e4d guibg=#4f4e4d gui=NONE
hi MatchParen  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi StatusLine  guifg=#e6e1de guibg=#4f4e4d gui=bold
hi StatusLineNC  guifg=#e6e1de guibg=#4f4e4d gui=NONE
hi Pmenu  guifg=#ffffff guibg=NONE gui=bold,underline,italic
hi PmenuSel  guifg=NONE guibg=#545d73 gui=NONE
hi IncSearch  guifg=NONE guibg=#3f5271 gui=NONE
hi Search  guifg=NONE guibg=#3f5271 gui=NONE
hi Directory  guifg=#6d9cbe guibg=NONE gui=NONE
hi Folded  guifg=#0b0b0b guibg=#2b2b2b gui=NONE

hi Normal  guifg=#e6e1de guibg=#2b2b2b gui=NONE
hi Boolean  guifg=#6e9cbe guibg=NONE gui=NONE
hi Character  guifg=#6d9cbe guibg=NONE gui=NONE
hi Comment  guifg=#0b0b0b guibg=#2a2a2a gui=italic
hi Conditional  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi Constant  guifg=#6d9cbe guibg=NONE gui=NONE
hi Define  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi ErrorMsg  guifg=#ffffff guibg=#990000 gui=italic
hi WarningMsg  guifg=#ffffff guibg=#990000 gui=italic
hi Float  guifg=#96d339 guibg=NONE gui=NONE
hi Function  guifg=#ff00ac guibg=#000000 gui=bold,italic
hi Identifier  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi Keyword  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi Label  guifg=#0069cc guibg=NONE gui=NONE
hi NonText  guifg=#333333 guibg=#393a3c gui=NONE
hi Number  guifg=#96d339 guibg=NONE gui=NONE
hi Operator  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi PreProc  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi Special  guifg=#e6e1de guibg=NONE gui=NONE
hi SpecialKey  guifg=#333333 guibg=#393a3c gui=NONE
hi Statement  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi StorageClass  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi String  guifg=#0069cc guibg=NONE gui=NONE
hi Tag  guifg=#000000 guibg=NONE gui=NONE
hi Title  guifg=#e6e1de guibg=NONE gui=bold
hi Todo  guifg=#0b0b0b guibg=#2a2a2a gui=inverse,bold,italic
hi Type  guifg=#ffffff guibg=NONE gui=bold,underline,italic
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi rubyFunction  guifg=#ff00ac guibg=#000000 gui=bold,italic
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=#6d9cbe guibg=NONE gui=NONE
hi rubyConstant  guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#0069cc guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=NONE guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=#c9ceff guibg=NONE gui=NONE
hi rubyInclude  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi rubyGlobalVariable  guifg=#c9ceff guibg=NONE gui=NONE
hi rubyRegexp  guifg=#0069cc guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#0069cc guibg=NONE gui=NONE
hi rubyEscape  guifg=#519f50 guibg=NONE gui=NONE
hi rubyControl  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi rubyClassVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyOperator  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi rubyException  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi rubyPseudoVariable  guifg=#c9ceff guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi rubyRailsARMethod  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi rubyRailsRenderMethod  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi rubyRailsMethod  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#0b0b0b guibg=#2a2a2a gui=italic
hi erubyRailsMethod  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi htmlTag  guifg=#000000 guibg=NONE gui=NONE
hi htmlEndTag  guifg=#000000 guibg=NONE gui=NONE
hi htmlTagName  guifg=#000000 guibg=NONE gui=NONE
hi htmlArg  guifg=#000000 guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#6d9cbe guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#69a1ff guibg=#2b2b2b gui=bold
hi javaScriptRailsFunction  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#000000 guibg=NONE gui=NONE
hi yamlAnchor  guifg=#c9ceff guibg=NONE gui=NONE
hi yamlAlias  guifg=#c9ceff guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#0069cc guibg=NONE gui=NONE
hi cssURL  guifg=NONE guibg=NONE gui=NONE
hi cssFunctionName  guifg=#00c5ff guibg=#2b2b2b gui=NONE
hi cssColor  guifg=#6d9cbe guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=#000000 guibg=NONE gui=NONE
hi cssClassName  guifg=#000000 guibg=NONE gui=NONE
hi cssValueLength  guifg=#96d339 guibg=NONE gui=NONE
hi cssCommonAttr  guifg=#a5c261 guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
