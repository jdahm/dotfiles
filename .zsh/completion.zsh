autoload -Uz compinit && compinit

# select from a menu if there are more than 5 matches
zstyle ':completion:*' menu select=5

# number of errors allowed by _approximate to increase with the length of what you have typed so far
zstyle -e ':completion:*:approximate:*' \
            max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# never 'cd' to parent directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# ignore completion functions for commands not present
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# describe options in full
zstyle ':completion:*:options' description 'yes'

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# separate matches into groups
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''

# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections   true
zstyle ':completion:*:man:*' menu yes select

# if you end up using a directory as argument, this will remove the trailing slash (useful in ln)
zstyle ':completion:*' squeeze-slashes true

# completing process IDs with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
    zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# hosts
[[ -r ~/.ssh/known_hosts ]] &&
    _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) ||
    _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()

hosts=(
$(hostname)
"$_ssh_hosts[@]"
"$_etc_hosts[@]"
localhost
)

zstyle ':completion:*:hosts' hosts $hosts
