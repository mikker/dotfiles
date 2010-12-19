" Maintainer: Mario Gutierrez (mario@mgutz.com)
" Original Theme: Dmitry Kichenko (dmitrykichenko@gmail.com)
" Last Change: Jun 23, 2010
" Version: 0.2

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "underwater-mod"

" Vim >= 7.0 specific colors
if version >= 700
  " highlights current line
  hi CursorLine guibg=#18374F
  " cursor's colour
  hi CursorColumn guibg=#ffffff
  "hi MatchParen guifg=#ffffff guibg=#439ea9 gui=bold
  hi MatchParen         guifg=magenta   guibg=bg        gui=bold
  hi Pmenu 		guifg=#dfeff6   guibg=#1E415E
  hi PmenuSel 	        guifg=#dfeff6   guibg=#2D7889

  " Search
  hi IncSearch          guifg=#E2DAEF   guibg=#AF81F4   gui=bold
  hi Search             guifg=#E2DAEF   guibg=#AF81F4   gui=none
endif

" General colors
hi Cursor 		guifg=NONE    guibg=#55A096 gui=none
hi Normal 		guifg=#e3f3fa guibg=#102235 gui=none
" e.g. tildes at the end of file
hi NonText 		guifg=#233f59 guibg=bg      gui=none
hi LineNr 		guifg=#233f59 guibg=bg      gui=none
hi StatusLine 	        guifg=#ffec99 guibg=#0a1721 gui=none
hi StatusLineNC         guifg=#233f59 guibg=#0a1721 gui=none
hi VertSplit 	        guifg=#0a1721 guibg=#0a1721 gui=none
hi Folded 		guifg=#68CEE8 guibg=#1A3951 gui=none
hi FoldColumn           guifg=#1E415E guibg=#1A3951 gui=none
 " Selected text color
hi Visual		guifg=#dfeff6 guibg=#24557A gui=none
hi Title 		guifg=#ef7760 guibg=bg      gui=none

" Syntax highlighting
"
hi Comment 		guifg=#3e71a1 guibg=bg      gui=italic
hi Todo 		guifg=#ADED80 guibg=bg      gui=bold
hi Constant 	        guifg=#96defa gui=none
hi String 		guifg=#89e14b gui=italic
 " names of variables in PHP
hi Identifier 	        guifg=#8ac6f2 gui=none
hi Ignore 		guifg=#233f59 guibg=bg      gui=none
 " Function names as in python. currently purleish
hi Function 	        guifg=#AF81F4 gui=none
 " declarations of type, e.g. int blah
hi Type 		guifg=#41B2EA gui=none
 " statement, such as 'hi' right here
hi Statement 	        guifg=#68CEE8 gui=none
hi Keyword		guifg=#8ac6f2 gui=none
 "  specified preprocessed words (like bold, italic etc. above)
hi PreProc 		guifg=#ef7760 gui=none
hi Number		guifg=#96defa gui=none
hi Special		guifg=#DFEFF6 gui=none
hi Underlined 	        guifg=#8ac6f2 gui=underline

hi TabLine              guifg=#585858 guibg=#dddddd gui=none
hi TabLineSel           guifg=#102335 guibg=#c5c5c5 gui=bold
hi TabLineFill 		guifg=fg guibg=#dddddd gui=none

" Ruby
hi rubyAccess                   guifg=#ef7760 guibg=bg gui=italic
hi rubyInterpolation            guifg=#b9e19d guibg=bg 

hi link rubyInterpolationDelimiter rubyInterpolation
hi link rubyStringDelimiter     String
"hi rubyRegexpEscape             guifg=#e2e8a2 guibg=bg
"hi link rubyRegexpCharClass     rubyRegexpEscape 

" ERB
hi link erubyDelimiter          PreProc 


" HTML
hi link htmlTag                 Statement
hi link htmlEndTag              Statement
hi link htmlTagName             Statement 

" HAML
hi link hamlAttributes          htmlArg
hi link hamlTag                 htmlTag 
hi link hamlTagName             htmlTagName 
hi link hamlIdChar              hamlId
hi link hamlClassChar           hamlClass

" XML
hi link xmlTag                  htmlTag
hi link xmlEndTag               htmlEndTag
hi link xmlTagName              htmlTagName

" NERDTree
hi link treePart                LineNr
hi link treePartFile            treePart 
hi link treeDirSlash            treePart
hi link treeDir                 Statement 
hi link treeClosable            PreProc
hi link treeOpenable            treeClosable
hi link treeUp                  treeClosable 
hi treeFlag                     guifg=#3e71a1 guibg=bg gui=none
hi link treeHelp                Comment
hi link treeLink                Type
hi link treeExecFile            Type

" Markdown
hi link mkdCode                Comment 
