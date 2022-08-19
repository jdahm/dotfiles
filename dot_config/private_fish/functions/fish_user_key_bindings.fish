function reverse_history_search
  history | fzf --no-sort | read -l command
  if test $command
    commandline -rb $command
  end
end

function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert -m default jk backward-char force-repaint

  # for accepting autosuggestions in vi mode
  # https://github.com/fish-shell/fish-shell/issues/3541#issuecomment-260001906
  for mode in insert default visual
    bind -M $mode \cf forward-char
  end

  bind -M default / reverse_history_search
end
