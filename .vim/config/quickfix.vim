function! quickfix#grep_quickfix(pat)
    let all = getqflist()
    for d in all
        if bufname(d['bufnr']) !~ a:pat && d['text'] !~ a:pat
            call remove(all, index(all,d))
        endif
    endfor
    call setqflist(all)
endfunction
command! -nargs=* GrepQF call quickfix#grep_quickfix(<q-args>)
