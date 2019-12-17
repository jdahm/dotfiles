# Disable features and return early if this is a dumb terminal
if [[ "$TERM" == "dumb" ]]; then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
  return
fi

# Enable autocompletions
autoload -Uz compinit && compinit
zmodload -i zsh/complist

# Load bashcompinit for some old bash completions
autoload bashcompinit && bashcompinit

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh/history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

# Options
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell

setopt auto_cd # cd by typing directory name if it's not a command

setopt correct_all # autocorrect commands

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Prompt
fpath+=("$HOME/.zsh/pure")
autoload -U promptinit && promptinit
prompt pure

# Other plugins
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Source local config if exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
