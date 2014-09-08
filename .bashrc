# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global bashrc
[ -f /etc/bashrc ] && . /etc/bashrc

# Prompt
prompt_err() {
    local Reset='\e[0m'
    local Blue='\e[0;34m'
    local Red='\e[0;31m'
    if test "$?" -eq 0; then
	    PS1="\[${Blue}\]\W\[${Reset}\] > "
    else
	    PS1="\[${Blue}\]\W\[${Reset}\] [\[\Red\]\?\[${Reset}\]] > "
    fi
}

PROMPT_COMMAND=prompt_err
PS2='    '

# Set mode
set -o emacs

# Options
shopt -s cdspell
shopt -s cmdhist
shopt -s extglob

# Local config
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
