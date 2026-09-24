# Bootstrap homebrew
/opt/homebrew/bin/brew shellenv | source
fish_add_path (brew --prefix)/opt/postgresql@15/bin

# Set PATH
fish_add_path $HOME/.local/bin $HOME/.amp/bin $HOME/.cargo/bin $HOME/go/bin /usr/local/bin

if status is-interactive
    set -g fish_greeting

    if command -qs brew
        abbr --add brew-update brew bundle --global
        if test -d (brew --prefix)"/share/fish/completions"
            set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)"/share/fish/vendor_completions.d"
            set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
    end

    set -g fish_color_command blue
    set -g sponge_purge_only_on_exit true

    # Settings for "pure" prompt
    set -g fish_transient_prompt 1
    set -g pure_enable_virtualenv false
    function fish_greeting
        _pure_check_for_new_release
    end

    if command -qs hx
        set -gx EDITOR hx
        set -gx VISUAL hx
        abbr --add --position command e hx
    end

    # GPG agent
    # I used to need this
    #set -gx GPG_TTY (tty)

    if command -qs chezmoi
        abbr --add chezmoi-cd cd (chezmoi source-path)
    end

    if command -qs eza
        abbr --add l eza
        abbr --add ll eza -l --header --icons
        abbr --add la eza -la --header --icons
        abbr --add tree eza --tree
        abbr --add lsize eza -lah --sort=size --reverse
    end

    if brew --prefix --installed llvm >/dev/null 2>&1
        fish_add_path -a (brew --prefix llvm)/bin
    end

    if command -qs zoxide
        zoxide init fish | source
    end

    if command -qs rustup
        fish_add_path (brew --prefix rustup)/bin
    end

    if command -qs direnv
        direnv hook fish | source
    end

    if command -qs kitten
        abbr --add --position command s kitten ssh
        abbr --add icat kitty +kitten icat --align=left
    end

    if test -d $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
        fish_add_path $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
    end

    if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end
end
