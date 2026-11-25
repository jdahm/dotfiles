/opt/homebrew/bin/brew shellenv | source

# PATH is set outside the interactive block so scripts and fish -c get it too.
# fish_add_path skips folders that don't exist.
fish_add_path $HOME/.local/bin $HOME/.amp/bin $HOME/.cargo/bin $HOME/go/bin /usr/local/bin
# rustup and libpq are keg-only, so cargo, rustc, psql and pg_dump aren't linked into the brew prefix
fish_add_path $HOMEBREW_PREFIX/opt/rustup/bin $HOMEBREW_PREFIX/opt/libpq/bin
fish_add_path $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts

if command -qs hx
    set -gx EDITOR hx
    set -gx VISUAL hx
end

if status is-interactive
    set -g fish_color_command blue
    set -g sponge_purge_only_on_exit true

    # Settings for the "pure" prompt
    set -g fish_transient_prompt 1
    set -g pure_enable_virtualenv false
    function fish_greeting
        _pure_check_for_new_release
    end

    abbr --add brew-update brew bundle --global

    if command -qs hx
        abbr --add --position command e hx
    end

    if command -qs eza
        abbr --add l eza
        abbr --add ll eza -l --header --icons
        abbr --add la eza -la --header --icons
        abbr --add tree eza --tree
        abbr --add lsize eza -lah --sort=size --reverse
    end

    if command -qs zoxide
        zoxide init fish | source
    end

    if command -qs direnv
        direnv hook fish | source
    end

    if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end
end
