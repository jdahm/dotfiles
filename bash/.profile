# Path settings
export PATH=~/bin:~/usr/bin:/usr/local/bin:${PATH}

# Sane defaults
export EMACS="emacs"
export EDITOR="emacs -nw"
export ALTERNATE_EDITOR=""
export VISUAL="${EDITOR}" # specify $EDITOR in machine-specific .profile.local
export PAGER="less"
export LESS="-R -X"

[ -f ~/.profile.local ] && source ~/.profile.local
