echo "⤵ Installing zsh..."
sudo apt-get -y install zsh
echo "✅ Successfully installed zsh version: $(zsh --version)"

echo "⤵ Configuring zsh tools in the $HOME directory..."
# Note: the install.sh script from zsh asks if you want to set the default shell to zsh
# We can pass that argument with "-s Y"

# We have to symlink the .zshrc before we curl the install script
# otherwise it would create a new .zshrc file 
echo "⤵ Symlinking your .zshrc file"
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
echo "✅ Successfully symlinked your .zshrc file"

(cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)
echo "✅ Successfully installed zsh tools"

echo "⤵ Changing the default shell to zsh"
sudo chsh -s $(which zsh) $USER
echo "✅ Successfully modified the default shell to $SHELL"