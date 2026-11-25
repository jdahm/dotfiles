# Homebrew is only used on macOS
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# PATH is set outside the interactive block so scripts and fish -c get it too.
# fish_add_path skips folders that don't exist.
fish_add_path $HOME/.local/bin $HOME/.amp/bin $HOME/.cargo/bin $HOME/go/bin /usr/local/bin
if set -q HOMEBREW_PREFIX
    # libpq is keg-only, so its psql and pg_dump aren't linked into the brew prefix
    fish_add_path $HOMEBREW_PREFIX/opt/libpq/bin
end
if test (uname) = Darwin
    fish_add_path $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
end

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
    # pure is installed by fisher, which hasn't run yet on a new machine
    if functions -q _pure_check_for_new_release
        function fish_greeting
            _pure_check_for_new_release
        end
    else
        set -g fish_greeting
    end

    if command -qs brew
        abbr --add brew-update brew bundle --global
    end

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
