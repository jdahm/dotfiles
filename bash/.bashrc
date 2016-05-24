# Sources:
# * https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set mode
set -o emacs

# Options
shopt -s cdspell
shopt -s cmdhist
shopt -s extglob

# Check the window size after each command and, if necessary, update
# the values of LINES and COLUMNS.
shopt -s checkwinsize

# Turn off suspend and resume feature (not needed in most modern terminals)
stty -ixon

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

# Add shell config files
configdir=~/.config/bash
if [ -d $configdir ]; then
    for f in $configdir/*; do source $f; done
fi

# # Prompt
if infocmp xterm-256color >/dev/null 2>&1 && [ -n "${VTE_VERSION}" ]; then
    export TERM='xterm-256color'
fi

if tput setaf 1 &>/dev/null; then
	tput sgr0 # reset colors
	bold=$(tput bold)
	reset=$(tput sgr0)
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0)
	blue=$(tput setaf 33)
	cyan=$(tput setaf 37)
	green=$(tput setaf 64)
	orange=$(tput setaf 166)
	purple=$(tput setaf 125)
	red=$(tput setaf 124)
	violet=$(tput setaf 61)
	white=$(tput setaf 15)
	yellow=$(tput setaf 136)
else
    bold=''
    reset="\e[0m"
    black="\e[0;30m"
    blue="\e[0;34m"
    cyan="\e[0;36m"
    green="\e[0;32m"
    orange="\e[0;33m"
    purple="\e[0;35m"
    red="\e[0;31m"
    violet="\e[0;35m"
    white="\e[0;37m"
    yellow="\e[0;33m"
fi

prompt_git() {
    local s=''
    local branchName=''

    local isbare=$(git rev-parse --is-bare-repository 2>&1)
    if [  "${isbare}" == "false" ]; then

        # Former check if the current directory is in a Git repository.
        # if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

	# check if the current directory is in .git before running git checks
	if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

	    # Ensure the index is up to date.
	    git update-index --really-refresh -q &>/dev/null

	    # Check for uncommitted changes in the index.
	    if ! $(git diff --quiet --ignore-submodules --cached); then
		s+='+'
	    fi

	    # Check for unstaged changes.
	    if ! $(git diff-files --quiet --ignore-submodules --); then
		s+='!'
	    fi

	    # Check for untracked files.
	    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
		s+='?'
	    fi

	    # Check for stashed files.
	    if $(git rev-parse --verify refs/stash &>/dev/null); then
		s+='$'
	    fi

	fi

	# Get the short symbolic ref.
	# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
	# Otherwise, just give up.
	branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')"

	[ -n "${s}" ] && s=" [${s}]"

	echo -e "${1}${branchName}${blue}${s}"
    elif [ "${isbare}" == "true" ]; then
        echo -e " ${blue}[bare]"
    fi
}

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}"
else
	userStyle="${orange}"
fi

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}"
else
	hostStyle="${yellow}"
fi

# Set the prompt
set-prompt() {
    sepcolor=$1
    # Set the terminal title to the current working directory.
    # PS1="\[\033]0;\w\007\]"
    PS1="\[${bold}\]" # begin bold
    PS1+="\[${userStyle}\]\u" # username
    PS1+="\[${sepcolor}\] at "
    PS1+="\[${hostStyle}\]\h" # host
    PS1+="\[${sepcolor}\] in "
    PS1+="\[${green}\]\w" # working directory
    PS1+="\$(prompt_git \"${sepcolor} on ${violet}\")" # Git repository details
    PS1+="\n"
    PS1+="\[${sepcolor}\]\$ \[${reset}\]" # `$` (and reset color)
    export PS1

    PS2="\[${yellow}\]→ \[${reset}\]"
    export PS2
}

# Prompt "themes"
prompt-dark-theme() { set-prompt $white; }
prompt-light-theme() { set-prompt $black; }

# Local config
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
