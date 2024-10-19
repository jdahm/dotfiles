set -U fish_greeting

# Bootstrap homebrew
if test -f ~/.config/brew/path
    fish_add_path -p (cat ~/.config/brew/path)/bin
    abbr --add brew-update brew bundle --cleanup --global
end

if command -qs brew
    if test -d (brew --prefix)"/share/fish/completions"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
       set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end

    source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
end

# Set PATH
fish_add_path $HOME/bin $HOME/go/bin /usr/local/bin $(brew --prefix)/opt/postgresql@15/bin 

# Editor
if command -qs nvim
    set -Ux EDITOR nvim
    set -Ux VISUAL nvim
    # alias vim to nvim
    abbr --add vim nvim
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

# chezmoi
if command -qs chezmoi
    abbr --add chezmoi-cd cd (chezmoi source-path)
end

# pyenv
pyenv init - | source

# tfenv
fish_add_path $HOME/.tfenv/bin
