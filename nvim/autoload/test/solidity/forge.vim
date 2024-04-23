if !exists('g:test#solidity#forge#file_pattern')
  let g:test#solidity#forge#file_pattern = '\v(\.t\.sol)$'
endif

function! test#solidity#forge#test_file(file) abort
  return a:file =~ g:test#solidity#forge#file_pattern
endfunction

function! test#solidity#forge#build_position(type, position) abort
  let path_with_leading_asterisk = "'**/" . a:position['file'] . "'"

  if a:type ==# 'nearest'
    let nearest_test = test#base#nearest_test(a:position, g:test#solidity#patterns, {})

    if !empty(nearest_test)
      return ["test", "--match-path", path_with_leading_asterisk, "--match-test", join(nearest_test['test'], ".")]
    else
      return ["test", "--match-path", path_with_leading_asterisk]
    endif
  elseif a:type ==# 'file'
    return ["test", "--match-path", path_with_leading_asterisk]
  else
    return ["test"]
  endif
endfunction

function! test#solidity#forge#build_args(args, color) abort
  return a:args
endfunction

function! test#solidity#forge#executable() abort
  return 'forge'
endfunction
