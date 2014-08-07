# Vi mode
bindkey -v

# Vim-like delete behavior
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

# Incremental search
bindkey -M vicmd '/' history-incremental-search-backward

# Remap escape key
bindkey -M viins 'jk' vi-cmd-mode

# Jump/kill line
bindkey -M viins '^x0' beginning-of-line
bindkey -M viins '^\'  beginning-of-line
bindkey -M viins '^e'  end-of-line
bindkey -M viins '^k'  kill-line

# Jump behind the first word on the cmdline from insert mode
jump_after_first_word() {
    local words
    words=(${(z)BUFFER})

    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}
    fi
}
zle -N jump_after_first_word
bindkey -M viins '^x1' jump_after_first_word

# Run command line as user root via sudo from insert mode
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line
bindkey -M viins '^xs' sudo-command-line

# Emulate CTRL-O from insert mode
ctrl-o() {
    emulate -LR zsh
    local keystr
    read -k keystr
    local -r keystr
    local -ri key=$(( #keystr ))
    zle ${${(z)$(bindkey -M vicmd $keystr)}[2]}
}
zle -N ctrl-o
bindkey -M viins '^o' ctrl-o

# Quick exit from normal mode
exit-shell() { exit; }
zle -N exit-shell
bindkey -M vicmd ':q' exit-shell

# Press M-D to insert the actual date in the form yyyy-mm-dd in either normal or insert mode
insert-datestamp() { LBUFFER+=${(%):-'%D{%Y%m%d}'}; }
insert-datestamp-dashes() { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp
zle -N insert-datestamp-dashes
bindkey -M vicmd '^[d' insert-datestamp
bindkey -M viins '^[d' insert-datestamp
bindkey -M vicmd '^[f' insert-datestamp-dashes
bindkey -M viins '^[f' insert-datestamp-dashes

# Press CTRL-B to insert the last typed word again in insert mode
insert-last-typed-word() { zle insert-last-word -- 0 -1 }
zle -N insert-last-typed-word
bindkey -M viins '^b' insert-last-typed-word
