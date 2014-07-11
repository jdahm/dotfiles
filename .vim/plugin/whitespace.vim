" Whitespace

" Remove trailing whitespace
nnoremap <leader>rtw :%s/\s\+$//e<CR>
" Remove real tabs
nnoremap <leader>rrt :%s/\t/        /ge<CR>
