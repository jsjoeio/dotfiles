#!/bin/sh

echo "Copying over keybindings for code-server"
cp -f code-server/keybindings.json  /home/coder/.local/share/code-server/User/keybindings.json

echo "Copying over settings for code-server"
cp -f code-server/settings.json  /home/coder/.local/share/code-server/User/settings.json


###########################
# zsh setup
###########################
echo -e "⤵ Installing zsh..."
sudo apt update && apt-get -y install zsh
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
   ln -s $HOME/dotfiles-test/.zshrc $HOME/.zshrc
   echo -e "✅ Successfully symlinked your .zshrc file"
else
   echo -e "\nUh-oh! .zshrc missing."
fi

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo -e "⤵ Changing the default shell"
sudo chsh -s $(which zsh) $USER
echo -e "✅ Successfully modified the default shell"

### neovim install and setup
sudo apt install -y software-properties-common 
sudo apt update && sudo add-apt-repository --yes ppa:neovim-ppa/unstable
sudo apt-get install -y neovim
echo -e "✅ Successfully installed neovim version: $(nvim --version)"