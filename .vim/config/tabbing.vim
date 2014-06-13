" Summarize tab config
function! tabbing#summarize_tabs()
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
command! SummarizeTabs call tabbing#summarize_tabs()

" Set tabstop, softtabstop and shiftwidth to the same value
function! tabbing#stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts  = l:tabstop
        let &l:sw  = l:tabstop
    endif
    call tabbing#summarize_tabs()
endfunction
command! -nargs=* Stab call tabbing#stab()

" Wrapping words for editing text
command! -nargs=* Wrap set wrap linebreak nolist
