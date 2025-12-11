# Bootstrap homebrew
if test -f ~/.config/brew/path
    fish_add_path -p (cat ~/.config/brew/path)/bin
end

# Set PATH
fish_add_path $HOME/bin $HOME/.cargo/bin $HOME/go/bin /usr/local/bin (brew --prefix)/opt/postgresql@15/bin

if status is-interactive
    if command -qs brew
        abbr --add brew-update brew bundle --global
        if test -d (brew --prefix)"/share/fish/completions"
            set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)"/share/fish/vendor_completions.d"
            set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
        source (brew --prefix)"/share/google-cloud-sdk/path.fish.inc"
    end

    function fish_greeting
        _pure_check_for_new_release
    end

    set -U fish_transient_prompt 1

    # Colors
    set -Ux fish_color_command blue

    # Editor
    set -Ux EDITOR vim
    set -Ux VISUAL vim
    abbr --add --position command e vim

    # sponge
    set sponge_purge_only_on_exit true

    if command -qs chezmoi
        abbr --add chezmoi-cd cd (chezmoi source-path)
    end

    if command -qs eza
        abbr --add ls eza
    end

    if command -qs zoxide
        zoxide init fish | source
    end

    if command -qs kitten
        abbr --add --position command s kitten ssh
        abbr --add icat kitty +kitten icat --align=left
    end

    if test -d $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
        fish_add_path $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
    end

end
