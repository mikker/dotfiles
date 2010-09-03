" Vim color file
" Converted from Textmate theme Twilight Bright using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "twilight_bright"

hi Cursor  guifg=NONE guibg=#a7a7a7 gui=NONE
hi Visual  guifg=NONE guibg=#6fa8d1 gui=NONE
hi CursorLine  guifg=NONE guibg=#f7f7f7 gui=NONE
hi CursorColumn  guifg=NONE guibg=#f7f7f7 gui=NONE
hi LineNr  guifg=#a0a0a0 guibg=#ffffff gui=NONE
hi VertSplit  guifg=#dbdbdb guibg=#dbdbdb gui=NONE
hi MatchParen  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi StatusLine  guifg=#404040 guibg=#dbdbdb gui=bold
hi StatusLineNC  guifg=#404040 guibg=#dbdbdb gui=NONE
hi Pmenu  guifg=#d15120 guibg=#fbefeb gui=NONE
hi PmenuSel  guifg=NONE guibg=#6fa8d1 gui=NONE
hi IncSearch  guifg=NONE guibg=#ced6e2 gui=NONE
hi Search  guifg=NONE guibg=#ced6e2 gui=NONE
hi Directory  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi Folded  guifg=#a49da5 guibg=#ffffff gui=NONE

hi Normal  guifg=#404040 guibg=#ffffff gui=NONE
hi Boolean  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi Character  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi Comment  guifg=#a49da5 guibg=#f6f5f6 gui=italic
hi Conditional  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi Constant  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi Define  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi ErrorMsg  guifg=NONE guibg=NONE gui=NONE
hi WarningMsg  guifg=NONE guibg=NONE gui=NONE
hi Float  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi Function  guifg=#d15120 guibg=#fbefeb gui=NONE
hi Identifier  guifg=#d2ad00 guibg=#f9f5e6 gui=NONE
hi Keyword  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi Label  guifg=#5f9411 guibg=#eff4e7 gui=NONE
hi NonText  guifg=#dbdbdb guibg=#f7f7f7 gui=NONE
hi Number  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi Operator  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi PreProc  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi Special  guifg=#404040 guibg=NONE gui=NONE
hi SpecialKey  guifg=#dbdbdb guibg=#f7f7f7 gui=NONE
hi Statement  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi StorageClass  guifg=#d2ad00 guibg=#f9f5e6 gui=NONE
hi String  guifg=#5f9411 guibg=#eff4e7 gui=NONE
hi Tag  guifg=#d15120 guibg=#fbefeb gui=NONE
hi Title  guifg=#404040 guibg=NONE gui=bold
hi Todo  guifg=#a49da5 guibg=#f6f5f6 gui=inverse,bold,italic
hi Type  guifg=#d15120 guibg=#fbefeb gui=NONE
hi Underlined  guifg=NONE guibg=NONE gui=underline
hi rubyClass  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi rubyFunction  guifg=#d15120 guibg=#fbefeb gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi rubyConstant  guifg=#a66bab guibg=#f6f0f7 gui=NONE
hi rubyStringDelimiter  guifg=#5f9411 guibg=#eff4e7 gui=NONE
hi rubyBlockParameter  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi rubyInstanceVariable  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi rubyInclude  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi rubyGlobalVariable  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi rubyRegexp  guifg=#32986f guibg=#f5faf8 gui=NONE
hi rubyRegexpDelimiter  guifg=#32986f guibg=#f5faf8 gui=NONE
hi rubyEscape  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi rubyControl  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi rubyClassVariable  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi rubyOperator  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi rubyException  guifg=#cf7900 guibg=#fdf8f2 gui=NONE
hi rubyPseudoVariable  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi rubyRailsUserClass  guifg=#a66bab guibg=#f6f0f7 gui=NONE
hi rubyRailsARAssociationMethod  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi rubyRailsARMethod  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi rubyRailsRenderMethod  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi rubyRailsMethod  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi erubyDelimiter  guifg=NONE guibg=NONE gui=NONE
hi erubyComment  guifg=#a49da5 guibg=#f6f5f6 gui=italic
hi erubyRailsMethod  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi htmlTag  guifg=#9f621d guibg=NONE gui=NONE
hi htmlEndTag  guifg=#9f621d guibg=NONE gui=NONE
hi htmlTagName  guifg=#9f621d guibg=NONE gui=NONE
hi htmlArg  guifg=#9f621d guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi javaScriptFunction  guifg=#d2ad00 guibg=#f9f5e6 gui=NONE
hi javaScriptRailsFunction  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#d15120 guibg=#fbefeb gui=NONE
hi yamlAnchor  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi yamlAlias  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi yamlDocumentHeader  guifg=#5f9411 guibg=#eff4e7 gui=NONE
hi cssURL  guifg=#6b82a7 guibg=#f0f3f6 gui=NONE
hi cssFunctionName  guifg=#00959e guibg=#e6f4f5 gui=NONE
hi cssColor  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi cssPseudoClassId  guifg=#d15120 guibg=#fbefeb gui=NONE
hi cssClassName  guifg=#d15120 guibg=#fbefeb gui=NONE
hi cssValueLength  guifg=#b23f1e guibg=#faf2ef gui=NONE
hi cssCommonAttr  guifg=#b23f1d guibg=#ffffff gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE
