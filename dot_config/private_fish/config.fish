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

# Local bin and lang executables
set PATH $HOME/bin $HOME/go/bin $PATH

# Set vi
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# set fish_key_bindings fish_user_key_bindings

# Hydro colors
set --global hydro_color_git green
set --global hydro_color_duration yellow
set --global hydro_color_prompt blue
set --global hydro_color_pwd magenta

# Direnv
direnv hook fish | source

alias chezmoi-cd="cd (chezmoi source-path)"

# Kitty
alias s="kitty +kitten ssh"
alias icat="kitty +kitten icat"
alias s="kitty +kitten ssh"
alias hg="kitty +kitten hyperlinked_grep"

if test -n "$KITTY_WINDOW_ID"
    alias e="edit-in-kitty"
else
    alias e=$EDITOR
end
