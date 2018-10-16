set fdm=indent

autocmd FileType javascript.jsx runtime! ftplugin/html/sparkup.vim

let b:ale_linters = ['prettier']
let b:ale_fixers = ['prettier']
