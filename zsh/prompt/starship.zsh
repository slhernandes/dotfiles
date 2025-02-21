  type starship_zle-keymap-select > /dev/null || {
      eval "$(starship init zsh)"
  }
  precmd_functions+=(set_win_title)
  setopt TRANSIENT_RPROMPT
