" spelling
if v:version >= 700
  " Enable spell check for text files
  autocmd BufNewFile,BufRead *.tex setlocal spell spelllang=en_us
endif

" indenting
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
