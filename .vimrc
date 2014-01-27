"{{{General

" Disable vi compatibility-mode
set nocompatible

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

"}}}

"{{{User interface

" Show line numbers
set number

" No annoying sound on errors
set noerrorbells
set novisualbell

" Enable mouse support in console
set mouse=a

" Give me some context!
set scrolloff=2

" Keep changes to the buffer without writing them when swiching
set hidden

"}}}

"{{{Searching

" Makes search act like search in modern browsers
set incsearch

" Ignoring case is a fun trick
set ignorecase
set smartcase

" Tab completion of filenames
set wildmode=longest,list

"}}}

"{{{Editing

" use 'jj' instead of <Esc>
ino jj <esc>
cno jj <c-c>
vno v <esc>

" Enable syntax highlighting
syntax enable

" Backspace behavior
set backspace=indent,eol,start

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Folding
set foldmethod=syntax
set foldlevelstart=1

" Space opens folds
nnoremap <Space> za

"}}}

"{{{Backup

" Sets how many lines of history VIM has to remember
set history=1000

" Make backup files
set backup

" Backup files go here
set backupdir=~/.vim/backup
" Swap files go here
set directory=~/.vim/temp

"}}}

"{{{Tabbing and indenting

set autoindent
set smartindent " indent when

" Use spaces instead of tabs
" 1 tab == 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4

" Formatting paragraphs
map Q gwip

"}}}

"{{{Plugins

" Pathogen
filetype off " Pathogen needs to run before plugin indent on
call pathogen#incubate()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
filetype plugin indent on

" ctrlp
let g:ctrlp_map = '<c-p>'
" Ack
map <leader>F :Ack<space>

"}}}

"{{{Look and Feel

" Always show statusline
set laststatus=2

" Theme

" Set colorscheme to solarized
colorscheme solarized
" Create F5 mapping to toggle colors
call togglebg#map("<F5>")
 
" Change the Solarized background to dark or light depending upon the time of
" day (5 refers to 5AM and 17 to 5PM). Change the background only if it is not
" already set to the value we want.
function! SetSolarizedBackground()
if strftime("%H") >= 5 && strftime("%H") < 17
if &background != 'light'
set background=light
endif
else
if &background != 'dark'
set background=dark
endif
endif
endfunction
 
" Set background on launch
call SetSolarizedBackground()
 
" Every time you save a file, call the function to check the time and change
" the background (if necessary).
if has("autocmd")
autocmd bufwritepost * call SetSolarizedBackground()
endif

"}}}

" vim: set et tw=4 sw=4
