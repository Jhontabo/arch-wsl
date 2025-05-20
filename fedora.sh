#!/bin/bash

set -e

echo "===== Updating the system ====="
sudo dnf update -y

echo "===== Installing basic packages ====="
sudo dnf install -y \
  zsh \
  git \
  htop \
  btop \
  tty-clock \
  cmatrix \
  cava \
  fastfetch \
  curl \
  gcc \
  fzf \
  ripgrep \
  fd-find \
  lazygit \
  neovim \
  unzip

# Symlink fd as 'fd' if not already (Fedora uses 'fdfind' as binary name)
if ! command -v fd &>/dev/null; then
  sudo ln -s $(which fdfind) /usr/local/bin/fd
fi

echo "===== Installing PHP ====="
sudo dnf install -y php php-cli php-mbstring php-xml php-json php-curl php-zip php-gd

echo "===== Installing Composer ====="
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm -f composer-setup.php

echo "===== Installing Node.js and npm ====="
sudo dnf install -y nodejs npm

echo "===== Installing MySQL (MariaDB) ====="
sudo dnf install -y mariadb-server mariadb

sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "===== Installing Java (OpenJDK 21) ====="
sudo dnf install -y java-21-openjdk java-21-openjdk-devel

echo "===== Installing Flatpak and adding Flathub ====="
sudo dnf install -y flatpak

if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "===== Installing extra software from Flathub ====="
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub com.rtosta.zapzap
flatpak install -y flathub org.apache.netbeans
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.getpostman.Postman
flatpak install -y flathub com.google.Chrome
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub us.zoom.Zoom
flatpak install -y flathub com.anydesk.Anydesk
flatpak install -y flathub io.dbeaver.DBeaverCommunity
flatpak install -y flathub org.filezillaproject.Filezilla
flatpak install -y flathub net.ankiweb.Anki
flatpak install -y flathub com.visualstudio.code
flatpak install -y flathub io.neovim.nvim

echo "===== Installing Nerd Fonts ====="
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
if [ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]; then
  curl -fLo JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
  unzip JetBrainsMono.zip
  rm JetBrainsMono.zip
fi
cd ~

echo "===== Cloning Dotfiles repository ====="
DOTFILES_REPO="https://github.com/Jhontabo/Dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "Dotfiles repo already exists at $DOTFILES_DIR"
fi
cp -f "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo "===== Setting up Neovim configuration ====="
NVIM_CONFIG_REPO="https://github.com/Jhontabo/Neovim.git"
CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$CONFIG_DIR" ]; then
  git clone "$NVIM_CONFIG_REPO" "$CONFIG_DIR"
else
  echo "Neovim config directory already exists at $CONFIG_DIR"
fi

echo "===== Installing Oh My Zsh and zsh plugins ====="
# Install Oh My Zsh (non-interactive)
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Update .zshrc plugins list
if grep -q "^plugins=" ~/.zshrc; then
  sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
else
  echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >>~/.zshrc
fi

echo "===== Set zsh as default shell ====="
chsh -s $(which zsh)

echo "===== All done ====="
echo "Log out and back in or restart your terminal to start using zsh with plugins."
echo "You may want to install any other favorite apps from Flathub, for example:"
echo "flatpak install flathub org.videolan.VLC"
echo "flatpak install flathub com.discordapp.Discord"
echo ""
echo "Enjoy Fedora! 🚀"
