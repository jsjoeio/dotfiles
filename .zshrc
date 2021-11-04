# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# GLOBALS
export TEST="hello world!"
export EDITOR="vim"
export PKG_CONFIG_PATH=/usr/bin/pkg-config

ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(
  git
  golang
  zsh-syntax-highlighting
  deno
)

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# For Go
export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export GOROOT=$HOME/go
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin
