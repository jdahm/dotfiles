# Path settings
export PATH=${HOME}/.local/bin:/usr/local/bin:${PATH}

# Sane defaults
export VISUAL="vim"
export PAGER="less"
export LESS="-F -R -X"
export EDITOR="vim"

[ -f ~/.profile.local ] && source ~/.profile.local
