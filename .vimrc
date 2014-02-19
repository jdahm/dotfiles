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

" Keep changes to the buffer without writing them when swiching
set hidden

" Shorter messages
set shortmess=a

" Disable mouse
set mouse=

if has("gui_running")
    " Set font
    set guifont=DejaVu\ Sans\ Mono:h12
endif

" Changing windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

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

" Wrapping words for editing text
command! -nargs=* Wrap set wrap linebreak nolist

" Toggle spell checking on and off with `<leader>s`
nmap <silent> <leader>s :set spell!<CR>

" Set region to USA English
set spelllang=en_us

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

" Simple indentation via autoindent
" Else, use the filetype plugins provided by vim
set autoindent

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts  = l:tabstop
        let &l:sw  = l:tabstop
    endif
    call SummarizeTabs()
endfunction

nmap <C-S-Tab> :call SummarizeTabs()<CR>
function! SummarizeTabs()
    try
        echohl ModeMsg
        echon 'tabstop='.&l:ts
        echon ' shiftwidth='.&l:sw
        echon ' softtabstop='.&l:sts
        if &l:et
            echon ' expandtab'
        else
            echon ' noexpandtab'
        endif
    finally
        echohl None
    endtry
endfunction

" Fix tabbing
function RemoveTabs()
    1,$s/\t/        /g
endfunction

command RT silent! call RemoveTabs()<CR>

" Strip trailing whitespace
function! StripTrailingWhitespaces()
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

command STW silent! call StripTrailingWhitespaces()<CR>

" }}}

" Look and feel {{{

" Statusline
set statusline=\ %f%m%r%h%w\ %=%({%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y}%)\ %([%l,%v][%p%%]\ %)

" Colorscheme
colorscheme base16-tomorrow

map <F5> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

" }}}

" Local configuration {{{

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" }}}
