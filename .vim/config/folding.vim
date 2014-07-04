" Folding options
" Only activate top-level folds and leave them open by default
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
