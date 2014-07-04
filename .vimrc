" Load plugins via pathogen
set nocompatible
filetype plugin off
call pathogen#infect() " Load plugins in ~/.vim/bundle
call pathogen#helptags() " Generate helptags for all plugins

" Colorscheme
colorscheme base16-default

" Load config files
runtime! config/*.vim

" Local config
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
