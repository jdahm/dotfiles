" ~/.ideavimrc sources this too, so keep Vim-only bits inside the has('ide') check

let mapleader = " "

set number
set scrolloff=5
set incsearch
set hlsearch
set ignorecase smartcase
set clipboard+=unnamed

packadd matchit        " % across tags and keywords

" Leave insert mode with jk
inoremap jk <Esc>

if !has('ide')
  syntax on
  filetype plugin indent on
endif
