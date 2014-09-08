# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global bashrc
[ -f /etc/bashrc ] && . /etc/bashrc

# Prompt
prompt_err() {
    if test "$?" -eq 0; then PS1='\[\e[1;34m\]\W\[\e[m\] > '; else PS1='\[\e[1;34m\]\W\[\e[m\] \[\e[0;31m\][$?]\[\e[m\] > '; fi
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
