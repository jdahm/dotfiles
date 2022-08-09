set -U fish_greeting

if test -f ~/.config/brew/path
    set PATH (cat ~/.config/brew/path)/bin $PATH
end

set PATH $HOME/bin $PATH

if status is-interactive
    alias vim=nvim
    alias vi=nvim
    set -x EDITOR nvim
    set -x VISUAL nvim

    if test -d (brew --prefix)"/share/fish/completions"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
       set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
    # Commands to run in interactive sessions can go here

    # Hydro colors
    set --global hydro_color_git green
    set --global hydro_color_duration yellow
    set --global hydro_color_prompt blue
    set --global hydro_color_pwd magenta

    alias chezmoi-cd="cd (chezmoi source-path)"

    function cd..
        cd ..
    end

    function ..
        cd ..
    end

    function sudo
        if test "$argv" = !!
            eval command sudo $history[1]
        else
            command sudo $argv
        end
    end
end

direnv hook fish | source
# trigger direnv at prompt, and on every arrow-based directory change (default)
set -g direnv_fish_mode eval_on_arrow
