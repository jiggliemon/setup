syntax enable

set number
set background=dark

" tab setings
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

colorscheme solarized

let g:solarized_termtrans = 0

command -nargs=? W :w !sudo tee %

