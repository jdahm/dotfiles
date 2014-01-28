#
# ~/.bashrc
#

# user-local executables
export PATH=/usr/local/bin:${PATH}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# temporary files
export TMPDIR="/tmp/$USER"
if [[ ! -d "$TMPDIR" ]]; then
	mkdir -p -m 700 "$TMPDIR"
fi

# alias
alias cp="cp -iv"
alias mv="mv -iv"
case "$(uname)" in
  Linux)
    alias rm="rm -Iv";;
  Darwin)
    alias rm="rm -iv";;
  *) ;;
esac
alias ln="ln -iv"

# MATLAB-like searching
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# history
#export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"


# shopt options
shopt -s cdspell        # This will correct minor spelling errors in a cd command.
shopt -s histappend     # Append to history rather than overwrite
shopt -s checkwinsize   # Check window after each command
shopt -s dotglob        # files beginning with . to be returned in the results of path-name expansion.
 
# set options
set -o vi               # vim-like keybindings
set -o noclobber        # prevent overwriting files with cat
set -o ignoreeof        # stops ctrl+d from logging me out

complete -cf sudo       # Tab complete for sudo

# display options
export GREP_OPTIONS="--color=auto"
export LESS="-R" # color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

if command -v lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN="$(which lesspipe.sh) %s"
fi

# add color
if command -v dircolors >/dev/null 2>&1; then
	eval $(dircolors -b ~/.dircolors)
	alias ls="ls --color=auto"
	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

# sane default programs
export VISUAL="vim"
export PAGER="less"
# left blank
export EDITOR=

# prompt
green=$(tput setaf 2)
blue=$(tput setaf 4)
white=$(tput setaf 7)
reset=$(tput sgr0)

# http://henrik.nyh.se/2008/12/git-dirty-prompt
# http://www.simplisticcomplexity.com/2008/03/13/...
# ...show-your-git-branch-name-in-your-prompt/
#   username@Machine ~/dev/dir[master]$   # clean working directory
#   username@Machine ~/dev/dir[master*]$  # dirty working directory
function parse_git_dirty {
	[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

#PS1='\[$blue\]\u \[$green\]\w \[$reset\]'
PS1='\[$blue\]\h \[$green\]$(shortdir) $(parse_git_branch) $ \[$reset\]'

# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)";
fi
export PATH=${HOME}/.pyenv/shims:${PATH}

# aliases
alias ipy="ipython"
alias ipy-gui="ipython qtconsole"

# Ruby (rbenv)
export RBENV_ROOT="${HOME}/.rbenv"
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)";
fi
export PATH=${HOME}/.rbenv/shims:${PATH}

# Tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

# User-local executables
export PATH=${HOME}/.local/bin:${PATH}

# local config
[[ -f ~/.bash_local ]] && source ~/.bash_local

