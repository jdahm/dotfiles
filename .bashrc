# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global bashrc
[ -f /etc/bashrc ] && . /etc/bashrc

# Prompt
prompt_err() {
    local EXIT="$?"
    local Black='\e[0;30m'
    local Red='\e[0;31m'
    local Green='\e[0;32m'
    local Yellow='\e[0;33m'
    local Blue='\e[0;34m'
    local Purple='\e[0;35m'
    local Cyan='\e[0;36m'
    local White='\e[0;37m'
    local Reset='\e[0m'
    if [ $EXIT -eq 0 ]; then
	    PS1="\[${Blue}\]\W\[${Reset}\] > "
    else
	    PS1="\[${Blue}\]\W\[${Reset}\] [\[${Red}\]${EXIT}\[${Reset}\]] > "
    fi
}

PROMPT_COMMAND=prompt_err
PS2="    "

# Set mode
set -o emacs

# Options
shopt -s cdspell
shopt -s cmdhist
shopt -s extglob

# Local config
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
