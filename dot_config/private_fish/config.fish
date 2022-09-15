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

if command -qs nvim
    alias vi=nvim
    alias vim=nvim
    set -Ux EDITOR nvim
    set -Ux VISUAL nvim
end

# vi keybindings
fish_vi_key_bindings
bind -M insert -m default jk backward-char force-repaint

# for accepting autosuggestions in vi mode
# https://github.com/fish-shell/fish-shell/issues/3541#issuecomment-260001906
for mode in insert default visual
    bind -M $mode \cf forward-char
end

# bind / in default mode to reverse_isearch from PatrickF1/fzf.fish
bind -M default / __fzf_reverse_isearch

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
