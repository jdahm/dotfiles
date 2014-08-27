" ctags and cscope tags handling

" add from git repository
set tags^=.git/tags

if has("cscope")
    if filereadable(".git/cscope.out")
        cscope add .git/cscope.out
    endif
endif
