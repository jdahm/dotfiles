" ctags and cscope tags handling

" add from git repository
set tags^=.git/tags

if has('cscope')
    set cscopetag cscopeverbose

    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif

    if filereadable(".git/cscope.out")
        cscope add .git/cscope.out
    elseif $CSCOPE_DB != ""
        cscope add $CSCOPE_DB
    endif

    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    cnoreabbrev css cs show
    cnoreabbrev csh cs help

endif
