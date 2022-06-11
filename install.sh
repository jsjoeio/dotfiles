#!/bin/sh

echo "Copying over keybindings for code-server"
cp -f code-server/keybindings.json $HOME/.local/share/code-server/User/keybindings.json

echo "Copying over settings for code-server"
cp -f code-server/settings.json $HOME/.local/share/code-server/User/settings.json

echo "Copying over .gitconfig"
cp -f .gitconfig $HOME/.gitconfig

echo "Copying over Neovim config"
mkdir -p $HOME/.config/nvim
cp -f nvim/init.lua $HOME/.config/nvim/init.lua

# Skip if not on Ubuntu
platform="$(lsb_release -d | awk -F"\t" '{print $2}')"

if ! [ -z "${platform##*Ubuntu*}"]; then
    echo "Not Ubuntu, found $platform"
    echo "Skipping zsh installation and rest of personalize script"
    exit 0
else
    echo "Found Ubuntu, continuing with script."
fi

###########################
# zsh setup
###########################
echo -e "⤵ Installing zsh..."
sudo apt update && sudo apt-get -y install zsh
echo -e "✅ Successfully installed zsh version: $(zsh --version)"

# Set up zsh tools
PATH_TO_ZSH_DIR=$HOME/.oh-my-zsh
echo -e "Checking if .oh-my-zsh directory exists at $PATH_TO_ZSH_DIR..."
if [ -d $PATH_TO_ZSH_DIR ]; then
    echo -e "\n$PATH_TO_ZSH_DIR directory exists!\nSkipping installation of zsh tools.\n"
else
    echo -e "\n$PATH_TO_ZSH_DIR directory not found."
    echo -e "⤵ Configuring zsh tools in the $HOME directory..."

    (cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)
    echo -e "✅ Successfully installed zsh tools"
fi

# Copy over .zshrc
cp -f .zshrc ~/.zshrc

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

# Install zsh theme/prompt.
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Install Rust
# NOTE: Dean suggested we do it here since we can't do it in the Dockerfile
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# sd is used with code-server development
cargo install sd

# switch shell to zsh
exec zsh
