" General {{{

" Disable vi compatibility-mode
set nocompatible

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ','

" }}}

" Plugins {{{

" Pathogen
call pathogen#incubate()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'

" }}}

" User interface {{{

" No annoying sound on errors
set noerrorbells
set novisualbell

" Keep changes to the buffer without writing them when swiching
set hidden

" Shorter messages
set shortmess=atI

" Mouse (uncomment below to enable)
" set mouse=a

" Changing windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Normal window splitting
set splitbelow
set splitright

" Window title
if has('title')
    set title
    set titleold=""
endif

" }}}

" Searching {{{

" Ignoring case is a fun trick
set smartcase

" Actions when hitting 'tab' to complete filenames, comma separated list
set wildmode=longest:full,full

" Search highlighting
set hlsearch

" Remove the highlighting when done
nnoremap <CR> :noh<CR>

nnoremap <silent> n :if v:searchforward <Bar> exe 'normal! n' <Bar> else <Bar> exe 'normal! N' <Bar> endif<CR>
nnoremap <silent> N :if v:searchforward <Bar> exe 'normal! N' <Bar> else <Bar> exe 'normal! n' <Bar> endif<CR>
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

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8
" Use Unix as the standard file type
set ffs=unix,dos,mac

" Automatically fold by syntax
set foldmethod=syntax
" ... but leave open by default
set nofoldenable
" Default to only top-level folds
set foldnestmax=1
" Use space to toggle folds
nnoremap <Space> za

" Wrapping words for editing text
command! -nargs=* Wrap set wrap linebreak nolist

" Set region to USA English
set spelllang=en_us

" }}}

" Backup {{{

" Sets how many lines of history VIM has to remember
set history=1000

" Make backups
set backup

" Backup files go here
set backupdir=~/.vim/backup
" Swap files go here
set directory=~/.vim/temp
" Undo files go here
set undodir=~/.vim/undo

" }}}

" Tabbing and indenting {{{

" Simple indentation via autoindent (inside vim-sensible)
" Else, use the filetype plugins provided by vim

" Set tabstop, softtabstop and shiftwidth to the same value
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts  = l:tabstop
        let &l:sw  = l:tabstop
    endif
    call SummarizeTabs()
endfunction
command! -nargs=* Stab call Stab()

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
command ST silent! call SummarizeTabs()<CR>

" Leader shortcuts
nmap <leader><Tab> :call SummarizeTabs()<CR>
nnoremap <leader>rtw :%s/\s\+$//e<CR>
nnoremap <leader>rrt :%s/\t/        /ge<CR>

" }}}

" Look and feel {{{

function! GitStatusline()
    " fugitive#statusline() works but I like this even more
    if !exists('b:git_dir')
        return ''
    endif
    return '['.fugitive#head(7).']'
endfunction

" Statusline
set statusline=\ %f                                                               " path to file
set statusline+=\ %-15.20(%m%r%h%)                                                " modified, read-only, and help flags
set statusline+=%=                                                                " switch to right side
set statusline+=\ %{GitStatusline()}                                       " fugitive status
set statusline+=\ %({%{&ff}\|%{strlen(&fenc)?&fenc:strlen(&enc)?&enc:none}\|%Y}%) " line endings | enc | filetype
set statusline+=\ %([%l,%v]%)                                                     " line and column number
set statusline+=\ %p%%                                                            " percent through file
set statusline+=\ [%n]                                                            " buffer number

" Colorscheme
colorscheme base16-default

" }}}

" Local configuration {{{

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" }}}
