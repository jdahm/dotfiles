if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    __vte_prompt_command
    eval $(dircolors ~/.dircolors)
fi
