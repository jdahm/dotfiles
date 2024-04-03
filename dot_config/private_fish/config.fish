set -U fish_greeting

# Homebrew
if test -f ~/.config/brew/path
    set PATH (cat ~/.config/brew/path)/bin $PATH
    alias brew-update="brew bundle --cleanup --global"
end

if command -qs brew
    if test -d (brew --prefix)"/share/fish/completions"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
       set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end

# Set PATH
fish_add_path $HOME/bin $HOME/go/bin /usr/local/bin $(brew --prefix)/opt/postgresql@15/bin 

if command -qs vim
    set -Ux EDITOR vim
    set -Ux VISUAL vim
end

# Hydro colors
set --global hydro_color_git green
set --global hydro_color_duration yellow
set --global hydro_color_prompt blue
set --global hydro_color_pwd magenta

# Sponge
set sponge_purge_only_on_exit true

# direnv
direnv hook fish | source

alias chezmoi-cd="cd (chezmoi source-path)"

# pyenv
pyenv init - | source

# tfenv
fish_add_path $HOME/.tfenv/bin

# kitty
alias s="kitty +kitten ssh"
alias icat="kitty +kitten icat"
alias hg="kitty +kitten hyperlinked_grep"

if test -n "$KITTY_WINDOW_ID"
    alias e="edit-in-kitty"
else
    alias e=$EDITOR
end

# Google Cloud
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"

function getmessh
infocmp -a xterm-kitty | ssh $argv[1] tic -x -o \~/.terminfo /dev/stdin
end
