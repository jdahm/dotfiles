# Open yazi, and when it quits, cd to the folder it was showing.
# From the yazi docs: https://yazi-rs.github.io/docs/quick-start#shell-wrapper
function y --description "yazi that changes the shell's folder on exit"
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
