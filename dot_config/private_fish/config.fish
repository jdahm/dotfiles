set -U fish_greeting
if test -f ~/.config/brew/path
    set PATH (cat ~/.config/brew/path)/bin $PATH
    alias brew-update-all="cat ~/.config/brew/Brewfile* | brew bundle --file=-"
end

set PATH $HOME/bin $PATH

alias vim=nvim
alias vi=nvim

if status is-interactive
    if test -d (brew --prefix)"/share/fish/completions"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
       set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
    # Commands to run in interactive sessions can go here
end

# Hydro colors
set --global hydro_color_git green
set --global hydro_color_duration yellow
set --global hydro_color_prompt blue
set --global hydro_color_pwd magenta
