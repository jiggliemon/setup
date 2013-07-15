syntax enable

set number
set background=dark

" tab setings
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

command -nargs=? W :w !sudo tee %

