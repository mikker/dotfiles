" Vim color file
" Converted from Textmate theme Sunburst using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "sunburst"

hi Cursor  guifg=NONE guibg=#a7a7a7 gui=NONE
hi Visual  guifg=NONE guibg=#3c424b gui=NONE
hi CursorLine  guifg=NONE guibg=#202229 gui=NONE
hi CursorColumn  guifg=NONE guibg=#202229 gui=NONE
hi LineNr  guifg=#86878b guibg=#14161e gui=NONE
hi VertSplit  guifg=#3f4147 guibg=#3f4147 gui=NONE
hi MatchParen  guifg=#e28964 guibg=NONE gui=NONE
hi StatusLine  guifg=#f8f8f8 guibg=#3f4147 gui=bold
hi StatusLineNC  guifg=#f8f8f8 guibg=#3f4147 gui=NONE
hi Pmenu  guifg=#89bdff guibg=NONE gui=NONE
hi PmenuSel  guifg=NONE guibg=#3c424b gui=NONE
hi IncSearch  guifg=NONE guibg=#223b5f gui=NONE
hi Search  guifg=NONE guibg=#223b5f gui=NONE
hi Directory  guifg=#3387cc guibg=NONE gui=NONE
hi Folded  guifg=#aeaeae guibg=#14161e gui=NONE

hi Normal  guifg=#f8f8f8 guibg=#14161e gui=NONE
hi Boolean  guifg=#3387cc guibg=NONE gui=NONE
hi Character  guifg=#3387cc guibg=NONE gui=NONE
hi Comment  guifg=#aeaeae guibg=NONE gui=italic
hi Conditional  guifg=#e28964 guibg=NONE gui=NONE
hi Constant  guifg=#3387cc guibg=NONE gui=NONE
hi Define  guifg=#e28964 guibg=NONE gui=NONE
hi ErrorMsg  guifg=NONE guibg=NONE gui=NONE
hi WarningMsg  guifg=NONE guibg=NONE gui=NONE
hi Float  guifg=#3387cc guibg=NONE gui=NONE
hi Function  guifg=#89bdff guibg=NONE gui=NONE
hi Identifier  guifg=#99cf50 guibg=NONE gui=NONE
hi Keyword  guifg=#e28964 guibg=NONE gui=NONE
hi Label  guifg=#65b042 guibg=NONE gui=NONE
hi NonText  guifg=#3e4551 guibg=#202229 gui=NONE
hi Number  guifg=#3387cc guibg=NONE gui=NONE
hi Operator  guifg=#e28964 guibg=NONE gui=NONE
hi PreProc  guifg=#e28964 guibg=NONE gui=NONE
hi Special  guifg=#f8f8f8 guibg=NONE gui=NONE
hi SpecialKey  guifg=#3e4551 guibg=#202229 gui=NONE
hi Statement  guifg=#e28964 guibg=NONE gui=NONE
hi StorageClass  guifg=#99cf50 guibg=NONE gui=NONE
hi String  guifg=#65b042 guibg=NONE gui=NONE
hi Tag  guifg=#89bdff guibg=NONE gui=NONE
hi Title  guifg=#f8f8f8 guibg=NONE gui=bold
hi Todo  guifg=#aeaeae guibg=NONE gui=inverse,bold,italic
hi Type  guifg=#89bdff guibg=NONE gui=NONE
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#e28964 guibg=NONE gui=NONE
hi rubyFunction  guifg=#89bdff guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=#3387cc guibg=NONE gui=NONE
hi rubyConstant  guifg=#9b859d guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#65b042 guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=#3e87e3 guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=#3e87e3 guibg=NONE gui=NONE
hi rubyInclude  guifg=#e28964 guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=#3e87e3 guibg=NONE gui=NONE
hi rubyRegexp  guifg=#e9c062 guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#e9c062 guibg=NONE gui=NONE
hi rubyEscape  guifg=#3387cc guibg=NONE gui=NONE
hi rubyControl  guifg=#e28964 guibg=NONE gui=NONE
hi rubyClassVariable  guifg=#3e87e3 guibg=NONE gui=NONE
hi rubyOperator  guifg=#e28964 guibg=NONE gui=NONE
hi rubyException  guifg=#e28964 guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=#3e87e3 guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=#9b859d guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=#dad085 guibg=NONE gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#aeaeae guibg=NONE gui=italic
hi erubyRailsMethod  guifg=#dad085 guibg=NONE gui=NONE
hi htmlTag  guifg=#89bdff guibg=NONE gui=NONE
hi htmlEndTag  guifg=#89bdff guibg=NONE gui=NONE
hi htmlTagName  guifg=#89bdff guibg=NONE gui=NONE
hi htmlArg  guifg=#89bdff guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#3387cc guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#99cf50 guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=#dad085 guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#89bdff guibg=NONE gui=NONE
hi yamlAnchor  guifg=#3e87e3 guibg=NONE gui=NONE
hi yamlAlias  guifg=#3e87e3 guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#65b042 guibg=NONE gui=NONE
hi cssURL  guifg=#3e87e3 guibg=NONE gui=NONE
hi cssFunctionName  guifg=#dad085 guibg=NONE gui=NONE
hi cssColor  guifg=#3387cc guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=#89bdff guibg=NONE gui=NONE
hi cssClassName  guifg=#89bdff guibg=NONE gui=NONE
hi cssValueLength  guifg=#3387cc guibg=NONE gui=NONE
hi cssCommonAttr  guifg=#cf6a4c guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
