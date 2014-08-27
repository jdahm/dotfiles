" Whitespace

" Remove trailing whitespace
function! whitespace#delete_trailing_whitespace()
    let line = line(".")
    let col = col(".")
    %s/\s\+$//e
    call cursor(line, col)
endfunction
command! DeleteTrailingWhitespace call whitespace#delete_trailing_whitespace()

