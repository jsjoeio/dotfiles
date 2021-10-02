# Path to your oh-my-zsh installation.
export ME=$(whoami)
export ZSH="$HOME/.oh-my-zsh"
# GLOBALS
export TEST="hello world!"
export EDITOR="vim"
export PKG_CONFIG_PATH=/usr/bin/pkg-config

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  golang
  zsh-syntax-highlighting
  deno
)

source $ZSH/oh-my-zsh.sh
# TODO add back in later
# source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# For Go
export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export GOROOT=$HOME/go
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin
