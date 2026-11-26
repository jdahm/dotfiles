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

    set -g fish_greeting

    # starship and zoxide run at every shell start, so ask mise for the installed
    # binary instead of using the shim. A shim exists even when its version isn't
    # installed yet, and calling it then prints errors or starts an install.
    if command -qs mise; and set -l starship (mise which starship 2>/dev/null)
        $starship init fish | source
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

    # Rust replacements: type the classic name, get the new tool
    if command -qs bat
        abbr --add cat bat --paging=never
        # Colored man pages
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    end
    command -qs fd; and abbr --add f fd
    command -qs dust; and abbr --add du dust
    command -qs btm; and abbr --add top btm

    abbr --add k kubectl
    abbr --add kg kubectl get
    abbr --add kgp kubectl get pods
    abbr --add kd kubectl describe
    abbr --add kl kubectl logs -f
    abbr --add kctx kubectx
    abbr --add kns kubens

    abbr --add g git
    abbr --add gs git status -s
    abbr --add gd git diff
    abbr --add gc git commit
    abbr --add gsw git switch

    abbr --add uvr uv run

    if command -qs eza
        abbr --add l eza
        abbr --add ll eza -l --header --icons
        abbr --add la eza -la --header --icons
        abbr --add tree eza --tree
        abbr --add lsize eza -lah --sort=size --reverse
    end

    # cd works as usual, and jumps to a frequently used folder when the path doesn't exist
    if command -qs mise; and set -l zoxide (mise which zoxide 2>/dev/null)
        $zoxide init fish --cmd cd | source
    end

    if command -qs direnv
        direnv hook fish | source
    end

    # Ctrl-R searches history with atuin. Up arrow stays fish's own prefix search.
    # atuin runs before and after every command, so put its real folder on PATH
    # instead of going through the mise shim each time.
    if command -qs mise; and set -l atuin (mise which atuin 2>/dev/null)
        fish_add_path --path --move (path dirname $atuin)
        atuin init fish --disable-up-arrow | source
    end

    if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end
end
