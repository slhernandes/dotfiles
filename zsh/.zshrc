# aliases
alias alert_fail='notify-send --urgency=critical -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cdf='cd $(find -maxdepth 6 -type d | fzf --height=50% --border=rounded --margin 5% --padding 5% --tmux=center)'
alias fortune="misfortune"
alias ls="ls -A --color=auto"
alias open="xdg-open"
alias pump="prime-run wine ~/.local/share/wineprefixes/default/drive_c/users/samuelhernandes/pumpsanity/Program64/PumpSanity.exe"
alias ranger="LC_ALL=C ranger"
alias tlupdate="sudo env PATH=$PATH tlmgr update --all"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias vim="nvim"
alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"

# completion style (case-insensitive)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
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

if [ "$TMUX" != "" ]; then
  export TERM="screen-256color"
  # export TERM="kitty"
fi

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

amixer -c 2 sset 'Mic Boost',0 0 &> /dev/null

voteaur(){
  ssh aur@aur.archlinux.org vote $1
}

mkcdir(){
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

weather(){
  curl v2.wttr.in/$1
}

rr(){
  sleep 2
  curl -s -L http://bit.ly/10hA8iC | bash
}

celar(){
  fortune | cowsay | lolcat
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

# opam configuration
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# ghcup-env
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" 

#OMNeT++ env
#[ -f "$HOME/Dokumente/srcs/omnetpp-6.0.3/setenv" ] && source "$HOME/Dokumente/srcs/omnetpp-6.0.3/setenv" > /dev/null 2> /dev/null

#inet env
#[ -f "$HOME/Dokumente/ba/cqf-fp-simulation/inet/setenv" ] && source "$HOME/Dokumente/ba/cqf-fp-simulation/inet/setenv" > /dev/null

#enable starship prompt
eval "$(starship init zsh)"
precmd_functions+=(set_win_title)
setopt TRANSIENT_RPROMPT

#plugins
PLUG=$ZSH_DIR/plugins
# old vi-mode
# source $PLUG/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $PLUG/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
# source $PLUG/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $PLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

typeset -aU path
