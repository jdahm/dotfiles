autoload colors
colors

_prompt_git_status () {
  local __git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$__git_branch" ]; then
    echo -n "%F{cyan}$__git_branch%f"
    if [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
      [ -n "$(git status --porcelain --untracked-files=no)" ] && echo -n "%F{red}!%f"
      [ -n "$(git status --porcelain | grep -m 1 '^??')" ] && echo -n "%F{red}?%f"
    fi
    echo -n " "
  fi
}

_prompt_indicator () {
  git rev-parse 2>/dev/null && echo -n "±" && return
  hg root >/dev/null 2>&1 && echo -n "☿" && return
  svn info >/dev/null 2>&1 && echo -n "⚡" && return
  echo -n "%(!.√.↪)"
}

zsh_prompt () {
    PROMPT="%F{blue}%1c%f $(_prompt_git_status)%F{yellow}$(_prompt_indicator)%f "
}

autoload -U add-zsh-hook
add-zsh-hook precmd zsh_prompt
