# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set mode
set -o emacs

# Options
shopt -s cdspell
shopt -s cmdhist
shopt -s extglob

# History
# Source: http://blog.sanctum.geek.nz/better-bash-history/
shopt -s histappend
HISTCONTROL=ignoreboth
HISTIGNORE='bg:fg:history'
HISTTIMEFORMAT='%F %T '
shopt -s cmdhist

# Make it harder to exit accidentally
# Require ^D 3 times to exit
export IGNOREEOF=2

# Navigation (pushd/popd, etc.)
alias p='pushd'
alias o='popd'
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

# Process information
alias psc='ps xawf -eo pid,user,cgroup,args'

# Functions
mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# Local config
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

# Add shell config files
configdir=~/.config/bash
if [ -d $configdir ]; then
    for f in $configdir/*; do source $f; done
fi

# Prompt
_prompt_err() {
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
    PS1="\[${Blue}\]\W\[${Reset}\] "
    [ $EXIT -ne 0 ] && PS1+="[\[${Red}\]${EXIT}\[${Reset}\]] "
    PS1+="> "
}

PROMPT_COMMAND=_prompt_err
PS2="    "
