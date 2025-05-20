#!/bin/bash
set -e

echo "===== Updating the system ====="
sudo dnf update -y || true

echo "===== Installing basic packages ====="
BASIC_PACKAGES=(
  zsh htop btop cmatrix cava fastfetch
  gcc fzf ripgrep fd-find neovim unzip
)

for pkg in "${BASIC_PACKAGES[@]}"; do
  sudo dnf install -y "$pkg" || echo "Warning: Failed to install $pkg, skipping..."
done

# Symlink fd as 'fd' if not already (Fedora uses 'fdfind' as binary name)
if ! command -v fd &>/dev/null; then
  sudo ln -s "$(which fdfind)" /usr/local/bin/fd || true
fi

echo "===== Installing PHP ====="
PHP_PACKAGES=(
  php php-cli php-mbstring php-xml php-json php-curl php-zip php-gd
)
for pkg in "${PHP_PACKAGES[@]}"; do
  sudo dnf install -y "$pkg" || echo "Warning: Failed to install $pkg"
done

echo "===== Installing Node.js and npm ====="
sudo dnf install -y nodejs npm || echo "Warning: Failed to install Node.js/npm"

echo "===== Installing MySQL (MariaDB) ====="
sudo dnf install -y mariadb-server mariadb || echo "Warning: MariaDB install failed"
sudo systemctl enable mariadb || true
sudo systemctl start mariadb || true

echo "===== Installing Java (OpenJDK 21) ====="
sudo dnf install -y java-21-openjdk java-21-openjdk-devel || echo "Warning: Java install failed"

echo "===== Installing Flatpak and adding Flathub ====="
sudo dnf install -y flatpak || echo "Warning: Flatpak install failed"
if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
fi

echo "===== Installing extra software from Flathub ====="
FLATPAK_APPS=(
  org.onlyoffice.desktopeditors com.rtosta.zapzap org.apache.netbeans
  md.obsidian.Obsidian org.telegram.desktop com.getpostman.Postman
  com.google.Chrome com.spotify.Client org.gimp.GIMP us.zoom.Zoom
  com.anydesk.Anydesk io.dbeaver.DBeaverCommunity
  org.filezillaproject.Filezilla net.ankiweb.Anki
  com.visualstudio.code
)

for app in "${FLATPAK_APPS[@]}"; do
  flatpak install -y flathub "$app" || echo "Warning: Failed to install $app"
done

echo "===== Installing Nerd Fonts ====="
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
if [ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]; then
  curl -fLo JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip &&
    unzip JetBrainsMono.zip && rm JetBrainsMono.zip || echo "Warning: Failed to install Nerd Font"
fi
cd ~

echo "===== Setting up Neovim configuration ====="
NVIM_CONFIG_REPO="https://github.com/Jhontabo/Neovim.git"
CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$CONFIG_DIR" ]; then
  git clone "$NVIM_CONFIG_REPO" "$CONFIG_DIR" || echo "Warning: Failed to clone Neovim config"
else
  echo "Neovim config directory already exists at $CONFIG_DIR"
fi

echo "===== Installing Oh My Zsh and plugins ====="
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "Warning: Oh My Zsh install failed"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true
fi

if grep -q "^plugins=" ~/.zshrc; then
  sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
else
  echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >>~/.zshrc
fi

echo "===== Set zsh as default shell ====="
chsh -s "$(which zsh)" || echo "Warning: Failed to set zsh as default shell"

echo "===== All done ====="
echo "✅ Log out and back in or restart your terminal to start using zsh with plugins."
echo "💡 You may want to install other apps from Flathub like:"
echo "flatpak install flathub org.videolan.VLC"
echo "flatpak install flathub com.discordapp.Discord"
echo ""
echo "🎉 Enjoy Fedora!"
