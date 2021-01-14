###########################
# README
# This script is meant to be used in Coder for my environment set up
# It assumes I'm using a base image that has Node, Yarn, Go and is Ubuntu-based.
###########################
echo -e "
░░░░░██╗░█████╗░███████╗██╗░██████╗  ██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░
░░░░░██║██╔══██╗██╔════╝╚█║██╔════╝  ██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░
░░░░░██║██║░░██║█████╗░░░╚╝╚█████╗░  ██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░
██╗░░██║██║░░██║██╔══╝░░░░░░╚═══██╗  ██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░
╚█████╔╝╚█████╔╝███████╗░░░██████╔╝  ██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗
░╚════╝░░╚════╝░╚══════╝░░░╚═════╝░  ╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝

░██████╗░█████╗░██████╗░██╗██████╗░████████╗
██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝
╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░
░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░
██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░
╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░
"
###########################



###########################
# Install Miscelleanous packages and tools 
###########################

# install jq
# helpful for installing vsx extensions
echo -e "\nInstalling jq..."
sudo apt-get -y install jq
echo -e "\nInstalled jq version $(jq --version)"

# for developing code-server
export PKG_CONFIG_PATH=/usr/bin/pkg-config

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# Install GNUPG
# needed to generate key to verify commits
sudo apt-get -y install gnupg

# For using NeoVim in VSCode
sudo apt-get -y install neovim

###########################
# End installing miscelleanous 
###########################



###########################
# zsh setup
###########################
echo -e "⤵ Installing zsh..."
sudo apt-get -y install zsh
echo -e "✅ Successfully installed zsh version: $(zsh --version)"

# Set up zsh tools
PATH_TO_ZSH_DIR=$HOME/.oh-my-zsh
echo -e "Checking if .oh-my-zsh directory exists at $PATH_TO_ZSH_DIR..."
if [ -d $PATH_TO_ZSH_DIR ]
then
   echo -e "\n$PATH_TO_ZSH_DIR directory exists!\nSkipping installation of zsh tools.\n"
else
   echo -e "\n$PATH_TO_ZSH_DIR directory not found."
   echo -e "⤵ Configuring zsh tools in the $HOME directory..."

   (cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)
   echo -e "✅ Successfully installed zsh tools"
fi

# Set up symlink for .zshrc
ZSHRC_LINK=$HOME/.zshrc
if [ -L ${ZSHRC_LINK} ] ; then
   if [ -e ${ZSHRC_LINK} ] ; then
      echo -e "\n.zshrc is symlinked corrected"
   else
      echo -e "\nOops! Your symlink appears to be broken."
   fi
elif [ -e ${ZSHRC_LINK} ] ; then
   echo -e "\nYour .zshrc exists but is not symlinked."
   # We have to symlink the .zshrc after we curl the install script
   # because the default zsh tools installs a new one, even if it finds ours
   rm $HOME/.zshrc
   echo -e "⤵ Symlinking your .zshrc file"
   ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
   echo -e "✅ Successfully symlinked your .zshrc file"
else
   echo -e "\nUh-oh! .zshrc missing."
fi

# Set the default shell
echo -e "⤵ Changing the default shell"
sudo chsh -s $(which zsh) $USER
echo -e "✅ Successfully modified the default shell"

###########################
# end zsh setup
###########################