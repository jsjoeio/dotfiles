echo "⤵ Installing zsh..."
sudo apt-get -y install zsh
echo "✅ Successfully installed zsh version: $(which zsh)"

echo "⤵ Configuring zsh tools in the $HOME directory..."
# Note: the install.sh script from zsh asks if you want to set the default shell to zsh
# We can pass that argument with "-s Y"
(cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s Y)")
echo "✅ Successfully installed zsh tools and set shell to $SHELL"
