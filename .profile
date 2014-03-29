# Path settings
export PATH=${HOME}/.local/bin:/usr/local/bin:${PATH}

# Sane default programs
export VISUAL="vim"
export PAGER="less"
export LESS="-F -R -X"
# left blank
export EDITOR="vim"

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)";
fi

if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)";
fi
