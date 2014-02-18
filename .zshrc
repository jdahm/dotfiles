#
# ~/.zshrc
# Johann Dahm
#

# prefix /usr/local path
path=(/usr/local/bin $path)

# Completion
autoload -Uz compinit
compinit

## select in menus
zstyle ':completion:*' menu select

## never 'cd' to parent directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## ignore completion functions for commands not present
zstyle ':completion:*:functions' ignored-patterns '_*'

## if you end up using a directory as argument, this will remove the trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true

## completing process IDs with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# Change directory without typing 'cd'
setopt autocd

# Extended glob
setopt extendedglob

# Need to type 'exit' to leave shell
setopt ignoreeof

# Allow comments inline
setopt interactivecomments

# Prevent from accidentally overwriting files
setopt noclobber

# Ignore the hangup signal
setopt nohup

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Aliases
alias vi="vim"

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -I"
alias ln="ln -i"

alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf
alias -s xz=tar -xJvf

## command H to command |head
alias -g H='| head'

## command L equivalent to command |less
alias -g L='|less'

## command S equivalent to command &> /dev/null &
alias -g S='&> /dev/null &'

# Dirstack
setopt autopushd pushdsilent pushdtohome

## remove duplicate entries
setopt pushdignoredups

## vim-like delete behavior
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

# User-local executables
path=(~/.local/bin $path)

# Sane default programs
export VISUAL="vim"
export PAGER="less"
# left blank
export EDITOR=

# Simple prompt
autoload colors
colors

_git_repo_name() {
    gittopdir=$(git rev-parse --git-dir 2> /dev/null)
    if [[ "foo$gittopdir" == "foo.git" ]]; then
        echo `basename $(pwd)`
    elif [[ "foo$gittopdir" != "foo" ]]; then
        echo `dirname $gittopdir | xargs basename`
    fi
}

_git_branch_name() {
    git branch 2>/dev/null | awk '/^\*/ { print $2 }'
}

_git_is_dirty() {
    git diff --quiet 2> /dev/null || echo '*'
}

git_custom_prompt() {
    if [ -d .git ] || $(git rev-parse --git-dir > /dev/null 2>&1); then
        echo "[% $(_git_branch_name)$(_git_is_dirty)]%"
    fi
}

setopt prompt_subst

# Right side
function zle-line-init zle-keymap-select {
VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
RPS1="${${KEYMAP/(vicmd|opp)/$VIM_PROMPT}/(main|viins)/} %{$fg_bold[cyan]%} $(git_custom_prompt) %{$reset_color%}"
zle reset-prompt
}
PS1="%{$fg[yellow]%}[%{$fg[blue]%}%m%{$fg[yellow]%}] [%{$fg[green]%}%c%{$fg[yellow]%}] : %{$reset_color%}"

zle -N zle-line-init
zle -N zle-keymap-select

# Vi mode
bindkey -v

## incremental search
bindkey -M vicmd '/' history-incremental-search-backward

## remap escape key
bindkey -M viins 'jk' vi-cmd-mode

### jump behind the first word on the cmdline.
### useful to add options.
function jump_after_first_word() {
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

# run command line as user root via sudo:
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line

bindkey -M viins '^xs' sudo-command-line

function ctrl-o
{
    emulate -LR zsh
    local keystr
    read -k keystr
    local -r keystr
    local -ri key=$(( #keystr ))
    # if (( key==##A )) ; then zle end-of-line
    # elif (( key==##$ )) ; then zle end-of-line
    # elif (( key==##I )) ; then zle vi-first-non-blank
    # elif (( key==##d )) ; then _-vi-delete
    # elif (( key==##0 )) && [[ -z $NUMERIC ]] ;
    # then zle beginning-of-line
    # elif (( key>=##0 && key<=##9 ))
    # then _-vi-digit-arg $(( key - ##0 )) _-vi-ctrl-o
    #     #elif (( key==##s )) ; then zle sedsubstitute
    #     #elif (( key==##= )) ; then zle tailfor
    # else
    zle ${${(z)$(bindkey -M vicmd $keystr)}[2]}
    # fi
}
zle -N ctrl-o

bindkey -M viins '^o' ctrl-o

#bindkey -M vicmd ':q' exit-shell

# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)";
fi
path=(~/.pyenv/shims $path)

# aliases
alias ipy="ipython"
alias ipy-gui="ipython qtconsole"

# Ruby (rbenv)
export RBENV_ROOT="${HOME}/.rbenv"
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)";
fi
path=(~/.rbenv/shims $path)

# Tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

# local config
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

