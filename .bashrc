#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$HOME/.local/bin:$PATH

# default programs
export TERMINAL="termite"
export BROWSER="firefox"
export EDITOR="vim"
export VISUAL="emacs"
export PAGER="less"

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

export LESSCOLORIZER="pygmentize"
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"

# add color
if [ -x /usr/bin/dircolors ]; then
	eval $(dircolors -b ~/.dircolors)
	alias ls="ls --color=auto"
	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi


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
set -o noclobber        # prevent overwriting files with cat
set -o ignoreeof        # stops ctrl+d from logging me out

complete -cf sudo       # Tab complete for sudo

# temporary files
export TMPDIR="/tmp/$USER"
if [[ ! -d "$TMPDIR" ]]; then
	mkdir -p -m 700 "$TMPDIR"
fi

# alias
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias ln="ln -iv"

# MATLAB-like searching
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

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

#PS1='\[$blue\]\u \[$green\]\w \[$white\]$ \[$reset\]'
PS1='\[$blue\]\h \[$green\]$(shortdir.sh) $(parse_git_branch)\[$white\]$ \[$reset\]'

# local config
[[ -f ~/.bash_local ]] && source ~/.bash_local

