###########################
# zsh setup
###########################
echo "⤵ Installing zsh..."
sudo apt-get -y install zsh
echo "✅ Successfully installed zsh version: $(zsh --version)"

# Set up zsh tools
PATH_TO_ZSH_DIR=$HOME/.oh-my-zsh
echo "Checking if .oh-my-zsh directory exists at $PATH_TO_ZSH_DIR..."
if [ -d $PATH_TO_ZSH_DIR ]
then
   echo "\n$PATH_TO_ZSH_DIR directory exists!\nSkipping installation of zsh tools.\n"
else
   echo "\n$PATH_TO_ZSH_DIR directory not found."
   echo "⤵ Configuring zsh tools in the $HOME directory..."

   (cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)
   echo "✅ Successfully installed zsh tools"
fi

# Set up symlink for .zshrc
ZSHRC_LINK=$HOME/.zshrc
if [ -L ${ZSHRC_LINK} ] ; then
   if [ -e ${ZSHRC_LINK} ] ; then
      echo "\n.zshrc is symlinked corrected"
   else
      echo "\nOops! Your symlink appears to be broken."
   fi
elif [ -e ${ZSHRC_LINK} ] ; then
   echo "\nYour .zshrc exists but is not symlinked."
   # We have to symlink the .zshrc after we curl the install script
   # because the default zsh tools installs a new one, even if it finds ours
   rm $HOME/.zshrc
   echo "⤵ Symlinking your .zshrc file"
   ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
   echo "✅ Successfully symlinked your .zshrc file"
else
   echo "\nUh-oh! .zshrc missing."
fi

echo "⤵ Changing the default shell"
sudo chsh -s $(which zsh) $USER
echo "✅ Successfully modified the default shell"