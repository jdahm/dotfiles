"
" ~/.vimrc
" Johann Dahm
"

" General {{{

" Disable vi compatibility-mode
set nocompatible

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ','

" automaticall re-read the file if possible
if v:version >= 600
    set autoread
endif

" }}}

" Plugins {{{

" Pathogen
filetype off " Pathogen needs to run before plugin indent on
call pathogen#incubate()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
filetype plugin indent on

" }}}

" User interface {{{

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

" Split windows horizontally at bottom
set splitbelow
" Split windows vertically on right
set splitright

" Shorter messages
set shortmess=a

" }}}

" Searching {{{

" Set search path for files
set path=.,,**

" Ignoring case is a fun trick
set smartcase

" }}}

" Editing {{{

" 'Hard' mode so I learn
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" use 'jk' instead of <Esc>
ino jk <esc>
cno jk <c-c>
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
" set foldlevelstart=1

" Space opens folds
nnoremap <Space> za

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Spellchecking
if exists("+spelllang")
    set spelllang=en_us
endif

" }}}

" Backup {{{

" Sets how many lines of history VIM has to remember
set history=1000

" Make backup files
set backup

" Backup files go here
set backupdir=~/.vim/backup
" Swap files go here
set directory=~/.vim/temp

" }}}

" Tabbing and indenting {{{

" Give tabs proper spacing
set tabstop=8

" Simple indentation via autoindent
" Else, use the filetype plugins provided by vim
set autoindent

" Formatting paragraphs
map Q gwip

" Fix tabbing
function RemoveTabs()
    1,$s/\t/        /g
endfunction

command RT call RemoveTabs()

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

" }}}

" Look and feel {{{

" Statusline
set statusline=\ %f%m%r%h%w\ %=%({%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y}%)\ %([%l,%v][%p%%]\ %)

" Colorscheme
colorscheme base16-default

" }}}

" Local configuration {{{

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" }}}
