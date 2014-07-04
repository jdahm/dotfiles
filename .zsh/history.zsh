# Import new commands from the history file also in other zsh-session
setopt append_history share_history

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups

# Remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

