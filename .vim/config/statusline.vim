" Source
"   - https://github.com/tommcdo/vimfiles/blob/master/config/statusline.vim

function! MyStatusLine()
    let l:s = ''
    " Left status
    let l:s .= '%<'
    let l:s .= '%{statusline#get_filename()}'
    let l:s .= ' %h'
    let l:s .= '%{&readonly?"*":""}'
    let l:s .= '%{&modified?"✗ ":""}'
    let l:s .= '%{(&modifiable&&!&modified)?"✓ ":""}'

    let l:s .= '%='

    " Right status
    let l:s .= s:git_branch()
    let l:s .= '%{argc()>0?("   A[".(argc()<10?repeat("-",argidx()).(expand("%")==argv(argidx())?"+":"~").repeat("-",argc()-argidx()-1):(argidx()+1)."/".argc())."]"):""}'
    let l:s .= '  '
    let l:s .= '%-14.(%l,%c%V%) '
    let l:s .= '%P'
    return l:s
endfunction

function! statusline#get_filename()
    if &filetype == 'help'
        let filename = expand('%:t')
    elseif &filetype == 'gitcommit'
        if expand('%') == '.git/index'
            let filename = 'git status'
        elseif expand('%:t') == 'COMMIT_EDITMSG'
            let filename = 'git commit'
        else
            let filename = 'git'
        endif
    else
        let filename = expand('%')
    endif
    return filename
endfunction

function! statusline#git_branch()
    return exists('b:git_dir') ? fugitive#head(7) : ''
endfunction

function! statusline#git_str(str)
    return exists('b:git_dir') ? a:str : ''
endfunction

function! s:git_branch()
    let l:s = ''
    let l:s .= '%{statusline#git_str("\u007b")}'
    let l:s .= '%{statusline#git_branch()}'
    let l:s .= '%{statusline#git_str("\u007d")}'
    return l:s
endfunction

set statusline=%!MyStatusLine()
