#. "$HOME/.cargo/env"


# XDG BASE DIRS
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DOCUMENTS_DIR=$HOME/Dokumente
#
# ZSHRC
export ZSHRC=$XDG_CONFIG_HOME/zsh/.zshrc

# general envs
export CLANGD_FLAGS=""
export MANPAGER='nvim +Man!'
export EDITOR=vim

# OMNeT++ env
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/omnetpp/include
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$XDG_DOCUMENTS_DIR/ba/cqf-fp-simulation/inet/src
#export OMNETPP_IMAGE_PATH=/opt/omnetpp/images
#export OMNETPP_TKENV_DIR=/opt/omnetpp/src/tkenv
#export PATH=$PATH:$HOME/Dokumente/srcs/omnetpp-6.0.2/bin
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/Dokumente/srcs/omnetpp-6.0.2/lib

# go directory
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# local scripts directory
export PATH=$PATH:$HOME/.local/bin

# starship config
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml

# texlive directory
export PATH=/usr/local/texlive/2023/bin/x86_64-linux:$PATH

# bun installation
export BUN_INSTALL="$HOME/.config/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# nvidia stuffs
export __GL_SYNC_TO_VBLANK=0

# rust stuffs
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# CUDA cache
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

# NPM config
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

# wget config
export WGETRC="$XDG_CONFIG_HOME"/wgetrc

# X11 config
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

# GTK config
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc":"$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"

# zsh-autosuggestion config
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
