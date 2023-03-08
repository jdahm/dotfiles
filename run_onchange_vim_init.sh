#!/usr/bin/env sh

vim -u NONE -c "helptags abolish/doc" -c q
vim -u NONE -c "helptags unimpaired/doc" -c q
vim -u NONE -c "helptags fugitive/doc" -c q
vim -u NONE -c "helptags vim-rhubarb/doc" -c q

