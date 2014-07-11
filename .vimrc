" Load plugins via pathogen
set nocompatible
filetype plugin off
call pathogen#infect() " Load plugins in ~/.vim/bundle
call pathogen#helptags() " Generate helptags for all plugins

" Configuration in .vim/plugin/*.vim

" Local config
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
