# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# GLOBALS
export TEST="hello world!"
export EDITOR="vim"
export PKG_CONFIG_PATH=/usr/bin/pkg-config

# sindresorhus/pure - beautiful prompt and theme
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(
  git
  golang
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# bun
BUN_INSTALL="/home/coder/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
