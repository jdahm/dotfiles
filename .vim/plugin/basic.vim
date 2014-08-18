" Sensible options for a modern Vim setup

" Use 'jk' instead of <esc> in insert and command line mode
ino jk <esc>
cno jk <c-c>
" Use 'v' instead of <esc> in visual mode
vno v <esc>

" Allow modified buffers to become hidden
set hidden

" Truncate long lines and skip startup message
set shortmess=tI

" Actions when hitting 'tab' to complete filenames, comma separated list
set wildmode=longest:full,full

" Sets how many lines of history Vim has to remember
set history=5000

" Window title
if has('title')
    set title
    set titleold=""
endif

" Skip redraw when executing macros, registers, etc.
set lazyredraw
