# oh-my-posh prompt
OMP_THEME_DIR_DEFAULT="/usr/share/oh-my-posh/themes"
OMP_THEME_DIR_CUSTOM="$XDG_CONFIG_HOME/oh-my-posh"

# OMP_CONFIG=${OMP_THEME_DIR_DEFAULT}/tokyonight_storm.omp.json
OMP_CONFIG=${OMP_THEME_DIR_CUSTOM}/starship.omp.toml
eval "$(oh-my-posh init zsh --config ${OMP_CONFIG})"

# omp vicmd integration
function _omp_redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done

  zle .reset-prompt
}

function _omp_zle-keymap-select() {
  if [ "$KEYMAP" = 'vicmd' ]; then
    export POSH_VI_MODE="<p:terminal-blue>❮</>"
  else
    export POSH_VI_MODE="<p:terminal-green>❯</>"
  fi

  _omp_redraw-prompt
}
_omp_create_widget zle-keymap-select _omp_zle-keymap-select

# reset to default mode at the end of line input reading
function _omp_zle-line-finish() {
  export POSH_VI_MODE="<p:terminal-green>❯</>"
  # export POSH_VI_MODE="I"
}
_omp_create_widget zle-line-finish _omp_zle-line-finish

# Fix a bug when you C-c in CMD mode, you'd be prompted with CMD mode indicator
# while in fact you would be in INS mode.
# Fixed by catching SIGINT (C-c), set mode to INS and repropagate the SIGINT,
# so if anything else depends on it, we will not break it.
TRAPINT() {
  export POSH_VI_MODE="<p:terminal-green>❯</>"
  return $(( 128 + $1 ))
}
