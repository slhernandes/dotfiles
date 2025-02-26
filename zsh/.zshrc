# aliases
alias alert_fail='notify-send --urgency=critical -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias fortune="misfortune"
alias ls="ls -A --color=auto"
alias open="xdg-open"
alias pump="prime-run wine ~/.local/share/wineprefixes/default/drive_c/users/samuelhernandes/pumpsanity/Program64/PumpSanity.exe"
alias ranger="LC_ALL=C ranger"
alias tlupdate="sudo env PATH=$PATH tlmgr update --all"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias vim="nvim"
alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"
alias glg="git log --graph"
alias glgo="git log --graph --oneline"
alias glog="git log --graph --oneline"
alias celar="fortune | cowsay | lolcat"

# completion style (case-insensitive)
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# raspbian style completion
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
autoload -Uz compinit && compinit

# bindkeys
bindkey -v
bindkey "^?" backward-delete-char
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "^y" autosuggest-accept
bindkey -s "^[[15~" "source $ZSHRC^m"

# history
ZSH_DIR=$XDG_CONFIG_HOME/zsh
HISTSIZE=100
HISTFILE=$ZSH_DIR/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# fzf shell integration
eval "$(fzf --zsh)"

if [ -z "$NVIM" ]; then
  fastfetch --logo-width 37 --logo-height 19
fi

if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh="kitty +kitten ssh"
fi

if [ -z "$WAYLAND_DISPLAY" ]; then
  xset r rate 150 50
fi

if [ -f /etc/bash.command-not-found ]; then
  . /etc/bash.command-not-found
fi

cdf(){
  input_path=$(find -maxdepth 6 -type d | fzf --prompt "cd to: " --preview 'tree -L 1 {}' --preview-window=right,35%)
  if [ -n "$input_path" ]; then
    cd $input_path
  else
    echo "[\033[1;31mError\033[0m] No directory specified." > /dev/stderr
  fi
}

voteaur(){
  ssh aur@aur.archlinux.org vote $1
}

mkcdir(){
  mkdir -p -- "$1" && cd -P -- "$1"
}

weather(){
  curl v2.wttr.in/$1
}

rr(){
  sleep 2
  curl -s -L http://bit.ly/10hA8iC | bash
}

set_win_title(){
  echo -ne "\033]0;$(basename "$PWD")\007"
}

function yz() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  /usr/bin/yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function chtsh() {
  curl cht.sh/$1 | less -R
}

# ghcup-env
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" 

FORCE_STARSHIP=0

ZSH_PROMPT="$ZSH_DIR/prompt"
if [ -n "$NVIM" ] || [ $FORCE_STARSHIP -ge 1 ]; then
  source "$ZSH_PROMPT/starship.zsh"
else
  source "$ZSH_PROMPT/ohmyposh.zsh"
fi

#plugins
PLUG=$ZSH_DIR/plugins
# old vi-mode
# source $PLUG/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $PLUG/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
# source $PLUG/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $PLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

typeset -aU path
