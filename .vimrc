" Disable vi compatibility-mode
set nocompatible

" Load plugins via pathogen
filetype plugin off
call pathogen#infect() " Load plugins in ~/.vim/bundle
call pathogen#helptags() " Generate helptags for all plugins

" Allow modified buffers to become hidden
set hidden

" Truncate long lines and skip startup message
set shortmess=tI

" Make backups
set backup

" Backup files go here
set backupdir=~/.vim/backup

" Sets how many lines of history Vim has to remember
set history=5000

" Actions when hitting 'tab' to complete filenames, comma separated list
set wildmode=longest:full,full

" Colorscheme
colorscheme base16-default

" Changing windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Use 'jk' instead of <esc> in insert and command line mode
ino jk <esc>
cno jk <c-c>
" Use 'v' instead of <esc> in visual mode
vno v <esc>

" Window title
if has('title')
    set title
    set titleold=""
endif

if has('syntax')
    " Set region to USA English
    set spelllang=en_us
endif

if has('folding')
    " Automatically fold by syntax
    set foldmethod=syntax
    " ... but leave open by default
    set nofoldenable
    " Default to only top-level folds
    set foldnestmax=1
    " Use space to toggle folds
    nnoremap <Space> za
endif

" 'Hard' mode
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Remove trailing whitespace
nnoremap <leader>rtw :%s/\s\+$//e<CR>
" Remove real tabs
nnoremap <leader>rrt :%s/\t/        /ge<CR>

" Load config files
runtime! config/*.vim

" Local config
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
