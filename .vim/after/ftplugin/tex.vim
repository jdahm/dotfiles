" spelling
if v:version >= 700
  " Enable spell check for text files
  autocmd BufNewFile,BufRead *.tex setlocal spell spelllang=en_us
endif
