# Homebrew is only used on macOS
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# PATH is set outside the interactive block so scripts and fish -c get it too.
# --path changes PATH for this session only, instead of saving to the universal
# fish_user_paths, so removing a line here removes the folder from PATH.
# fish_add_path skips folders that don't exist.
fish_add_path --path $HOME/.local/bin $HOME/.amp/bin $HOME/.cargo/bin $HOME/go/bin /usr/local/bin
if set -q HOMEBREW_PREFIX
    # libpq is keg-only, so its psql and pg_dump aren't linked into the brew prefix
    fish_add_path --path $HOMEBREW_PREFIX/opt/libpq/bin
end
if test (uname) = Darwin
    fish_add_path --path $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
end
# Tools from ~/.config/mise/config.toml, through shims. This goes last so the shims come first in PATH.
if command -qs mise
    mise activate fish --shims | source
end

if command -qs hx
    set -gx EDITOR hx
    set -gx VISUAL hx
end

if status is-interactive
    set -g fish_color_command blue
    set -g sponge_purge_only_on_exit true

    set -g fish_greeting

    if command -qs starship
        starship init fish | source
        # Collapse earlier prompts to a bare ❯ so scrollback stays readable
        function starship_transient_prompt_func
            set_color magenta
            echo -n '❯ '
            set_color normal
        end
        # Earlier prompts drop the right side
        function starship_transient_rprompt_func
        end
        enable_transience
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

    # cd works as usual, and jumps to a frequently used folder when the path doesn't exist
    if command -qs zoxide
        zoxide init fish --cmd cd | source
    end

    if command -qs direnv
        direnv hook fish | source
    end

    if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end
end
