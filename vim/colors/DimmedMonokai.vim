" Vim color file
" Converted from Textmate theme Dimmed - Monokai using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Dimmed - Monokai"

hi Cursor ctermfg=234 ctermbg=202 cterm=NONE guifg=#1e1e1e guibg=#fc5604 gui=NONE
hi Visual ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#373b41 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#2f2f2f gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#2f2f2f gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#2f2f2f gui=NONE
hi LineNr ctermfg=59 ctermbg=236 cterm=NONE guifg=#727372 guibg=#2f2f2f gui=NONE
hi VertSplit ctermfg=239 ctermbg=239 cterm=NONE guifg=#4e4f4f guibg=#4e4f4f gui=NONE
hi MatchParen ctermfg=59 ctermbg=NONE cterm=underline guifg=#676867 guibg=NONE gui=underline
hi StatusLine ctermfg=251 ctermbg=239 cterm=bold guifg=#c5c8c6 guibg=#4e4f4f gui=bold
hi StatusLineNC ctermfg=251 ctermbg=239 cterm=NONE guifg=#c5c8c6 guibg=#4e4f4f gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#373b41 gui=NONE
hi IncSearch ctermfg=234 ctermbg=107 cterm=NONE guifg=#1e1e1e guibg=#9aa83a gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=105 ctermbg=234 cterm=NONE guifg=#8080ff guibg=#1e1e1e gui=NONE
hi Folded ctermfg=102 ctermbg=234 cterm=NONE guifg=#9a9b99 guibg=#1e1e1e gui=NONE

hi Normal ctermfg=251 ctermbg=234 cterm=NONE guifg=#c5c8c6 guibg=#1e1e1e gui=NONE
hi Boolean ctermfg=198 ctermbg=NONE cterm=NONE guifg=#ff0080 guibg=NONE gui=NONE
hi Character ctermfg=105 ctermbg=234 cterm=NONE guifg=#8080ff guibg=#1e1e1e gui=NONE
hi Comment ctermfg=102 ctermbg=NONE cterm=NONE guifg=#9a9b99 guibg=NONE gui=NONE
hi Conditional ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=59 ctermbg=NONE cterm=NONE guifg=#676867 guibg=NONE gui=NONE
hi DiffAdd ctermfg=251 ctermbg=64 cterm=bold guifg=#c5c8c6 guibg=#44810b gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#890606 guibg=NONE gui=NONE
hi DiffChange ctermfg=251 ctermbg=23 cterm=NONE guifg=#c5c8c6 guibg=#1f3453 gui=NONE
hi DiffText ctermfg=251 ctermbg=24 cterm=bold guifg=#c5c8c6 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff0b00 guibg=NONE gui=NONE
hi WarningMsg ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff0b00 guibg=NONE gui=NONE
hi Float ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi Function ctermfg=166 ctermbg=NONE cterm=NONE guifg=#ce6700 guibg=NONE gui=NONE
hi Identifier ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi Keyword ctermfg=59 ctermbg=NONE cterm=NONE guifg=#676867 guibg=NONE gui=NONE
hi Label ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi NonText ctermfg=59 ctermbg=235 cterm=NONE guifg=#4b4e55 guibg=#262726 gui=NONE
hi Number ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi Operator ctermfg=59 ctermbg=NONE cterm=NONE guifg=#676867 guibg=NONE gui=NONE
hi PreProc ctermfg=59 ctermbg=NONE cterm=NONE guifg=#676867 guibg=NONE gui=NONE
hi Special ctermfg=251 ctermbg=NONE cterm=NONE guifg=#c5c8c6 guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=236 cterm=NONE guifg=#4b4e55 guibg=#2f2f2f gui=NONE
hi Statement ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi StorageClass ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi String ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi Tag ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi Title ctermfg=251 ctermbg=NONE cterm=bold guifg=#c5c8c6 guibg=NONE gui=bold
hi Todo ctermfg=102 ctermbg=NONE cterm=inverse,bold guifg=#9a9b99 guibg=NONE gui=inverse,bold
hi Type ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi rubyFunction ctermfg=166 ctermbg=NONE cterm=NONE guifg=#ce6700 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi rubyConstant ctermfg=167 ctermbg=NONE cterm=NONE guifg=#c7444a guibg=NONE gui=NONE
hi rubyStringDelimiter ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyInclude ctermfg=178 ctermbg=NONE cterm=NONE guifg=#d9b700 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi rubyRegexp ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi rubyEscape ctermfg=105 ctermbg=234 cterm=NONE guifg=#8080ff guibg=#1e1e1e gui=NONE
hi rubyControl ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=59 ctermbg=NONE cterm=NONE guifg=#676867 guibg=NONE gui=NONE
hi rubyException ctermfg=178 ctermbg=NONE cterm=NONE guifg=#d9b700 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=167 ctermbg=NONE cterm=NONE guifg=#c7444a guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi erubyComment ctermfg=102 ctermbg=NONE cterm=NONE guifg=#9a9b99 guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi htmlTag ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi htmlEndTag ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi htmlTagName ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi htmlArg ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=105 ctermbg=234 cterm=NONE guifg=#8080ff guibg=#1e1e1e gui=NONE
hi javaScriptFunction ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi javaScriptRailsFunction ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi yamlAlias ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=107 ctermbg=NONE cterm=NONE guifg=#9aa83a guibg=NONE gui=NONE
hi cssURL ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi cssFunctionName ctermfg=97 ctermbg=NONE cterm=NONE guifg=#9872a2 guibg=NONE gui=NONE
hi cssColor ctermfg=105 ctermbg=234 cterm=NONE guifg=#8080ff guibg=#1e1e1e gui=NONE
hi cssPseudoClassId ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi cssClassName ctermfg=179 ctermbg=NONE cterm=NONE guifg=#d0b344 guibg=NONE gui=NONE
hi cssValueLength ctermfg=67 ctermbg=NONE cterm=NONE guifg=#6089b4 guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=167 ctermbg=NONE cterm=NONE guifg=#c7444a guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE