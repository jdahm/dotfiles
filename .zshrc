# Source external config files
source ~/.zsh/completion.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/util.zsh
source ~/.zsh/history.zsh

# Zsh functions
autoload -Uz zargs
autoload -Uz zcalc
autoload -Uz zmv
autoload -Uz age

# Extended glob
setopt extended_glob

# Try to avoid the 'zsh: no matches found...'
setopt nonomatch

# Change directory without typing 'cd'
setopt auto_cd

# Report the status of backgrounds jobs immediately
setopt notify

# Display PID when suspending processes as well
setopt longlistjobs

# Need to type 'exit' to leave shell
setopt ignoreeof

# Allow comments inline
setopt interactivecomments

# Not just at the end
setopt completeinword

# Prevent from accidentally overwriting files
setopt noclobber

# Ignore the hangup signal
setopt nohup

# * shouldn't match dotfiles. ever.
setopt noglobdots

# Use zsh style word splitting
setopt noshwordsplit

# Dirstack
setopt autopushd pushdsilent pushdtohome

# Remove duplicate entries
setopt pushdignoredups

# local config
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
