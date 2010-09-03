" Vim color file
" Converted from Textmate theme Coda using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "coda"

hi Cursor  guifg=NONE guibg=#000000 gui=NONE
hi Visual  guifg=NONE guibg=#a7caff gui=NONE
hi CursorLine  guifg=NONE guibg=#eef1f5 gui=NONE
hi CursorColumn  guifg=NONE guibg=#eef1f5 gui=NONE
hi LineNr  guifg=#808080 guibg=#ffffff gui=NONE
hi VertSplit  guifg=#cfcfcf guibg=#cfcfcf gui=NONE
hi MatchParen  guifg=#000000 guibg=NONE gui=NONE
hi StatusLine  guifg=#000000 guibg=#cfcfcf gui=bold
hi StatusLineNC  guifg=#000000 guibg=#cfcfcf gui=NONE
hi Pmenu  guifg=NONE guibg=NONE gui=NONE
hi PmenuSel  guifg=NONE guibg=#a7caff gui=NONE
hi IncSearch  guifg=NONE guibg=#ababab gui=NONE
hi Search  guifg=NONE guibg=#ababab gui=NONE
hi Directory  guifg=#916319 guibg=NONE gui=NONE
hi Folded  guifg=#3c802c guibg=#ffffff gui=NONE

hi Normal  guifg=#000000 guibg=#ffffff gui=NONE
hi Boolean  guifg=#000000 guibg=NONE gui=NONE
hi Character  guifg=#916319 guibg=NONE gui=NONE
hi Comment  guifg=#3c802c guibg=NONE gui=italic
hi Conditional  guifg=#aa2063 guibg=NONE gui=NONE
hi Constant  guifg=NONE guibg=NONE gui=NONE
hi Define  guifg=#000000 guibg=NONE gui=NONE
hi ErrorMsg  guifg=#eb291c guibg=NONE gui=NONE
hi WarningMsg  guifg=#eb291c guibg=NONE gui=NONE
hi Float  guifg=#0f20f6 guibg=NONE gui=NONE
hi Function  guifg=#053369 guibg=NONE gui=NONE
hi Identifier  guifg=#aa2063 guibg=NONE gui=NONE
hi Keyword  guifg=#000000 guibg=NONE gui=NONE
hi Label  guifg=#ed7722 guibg=NONE gui=NONE
hi NonText  guifg=#bfbfbf guibg=#eef1f5 gui=NONE
hi Number  guifg=#0f20f6 guibg=NONE gui=NONE
hi Operator  guifg=#000000 guibg=NONE gui=NONE
hi PreProc  guifg=#000000 guibg=NONE gui=NONE
hi Special  guifg=#000000 guibg=NONE gui=NONE
hi SpecialKey  guifg=#bfbfbf guibg=#eef1f5 gui=NONE
hi Statement  guifg=#aa2063 guibg=NONE gui=NONE
hi StorageClass  guifg=#aa2063 guibg=NONE gui=NONE
hi String  guifg=#ed7722 guibg=NONE gui=NONE
hi Tag  guifg=#a21297 guibg=NONE gui=NONE
hi Title  guifg=#000000 guibg=NONE gui=bold
hi Todo  guifg=#3c802c guibg=NONE gui=inverse,bold,italic
hi Type  guifg=NONE guibg=NONE gui=NONE
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#aa2063 guibg=NONE gui=NONE
hi rubyFunction  guifg=#053369 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=#916319 guibg=NONE gui=NONE
hi rubyConstant  guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#ed7722 guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=#053369 guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=#916319 guibg=NONE gui=NONE
hi rubyInclude  guifg=#000000 guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=#000000 guibg=NONE gui=NONE
hi rubyRegexp  guifg=#ed7722 guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#ed7722 guibg=NONE gui=NONE
hi rubyEscape  guifg=#916319 guibg=NONE gui=NONE
hi rubyControl  guifg=#aa2063 guibg=NONE gui=NONE
hi rubyClassVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyOperator  guifg=#000000 guibg=NONE gui=NONE
hi rubyException  guifg=#000000 guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=#916319 guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=#7520af guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=#7520af guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=#7520af guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=#7520af guibg=NONE gui=NONE
hi erubyDelimiter  guifg=#ea291c guibg=NONE gui=NONE
hi erubyComment  guifg=#3c802c guibg=NONE gui=italic
hi erubyRailsMethod  guifg=#7520af guibg=NONE gui=NONE
hi htmlTag  guifg=#a21297 guibg=NONE gui=NONE
hi htmlEndTag  guifg=#a21297 guibg=NONE gui=NONE
hi htmlTagName  guifg=#a21297 guibg=NONE gui=NONE
hi htmlArg  guifg=#a21297 guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#916319 guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#aa2063 guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=#7520af guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#a21297 guibg=NONE gui=NONE
hi yamlAnchor  guifg=#000000 guibg=NONE gui=NONE
hi yamlAlias  guifg=#000000 guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#ed7722 guibg=NONE gui=NONE
hi cssURL  guifg=#053369 guibg=NONE gui=NONE
hi cssFunctionName  guifg=#7520af guibg=NONE gui=NONE
hi cssColor  guifg=#916319 guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=#b14e00 guibg=NONE gui=NONE
hi cssClassName  guifg=#b14e00 guibg=NONE gui=NONE
hi cssValueLength  guifg=#0f20f6 guibg=NONE gui=NONE
hi cssCommonAttr  guifg=NONE guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
