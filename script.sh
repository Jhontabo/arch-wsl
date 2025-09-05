#!/bin/bash
set -e

echo "===== Updating system ====="
sudo pacman -Syu --noconfirm

echo "===== Installing Zsh and Oh My Zsh ====="
sudo pacman -S --noconfirm zsh git curl

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Plugins

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

echo "===== Installing PHP ====="
PHP_PACKAGES=(
  php php-cli php-intl php-curl php-gd php-zip
)
for pkg in "${PHP_PACKAGES[@]}"; do
  sudo pacman -S --noconfirm "$pkg" || echo "Warning: Failed to install $pkg"
done

echo "===== Installing Node.js and npm ====="
sudo pacman -S --noconfirm nodejs npm || echo "Warning: Failed to install Node.js or npm"

echo "===== Installing MariaDB ====="
sudo pacman -S --noconfirm mariadb || echo "Warning: Failed to install MariaDB"

sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "===== Installing Java (OpenJDK disponible en repositorios) ====="
sudo pacman -S --noconfirm jdk-openjdk jre-openjdk
java -version

echo "===== Installing Homebrew ====="
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew first..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ||
    echo "Warning: Failed to install Homebrew"

  # Set up Homebrew in PATH
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ||
    echo "Warning: Failed to set up Homebrew environment"
fi

brew install neovim
nvim --version

if ! command -v rustc &>/dev/null; then
  echo "Installing Rust…"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$HOME/.cargo/bin:$PATH"
  rustc --version
fi

echo "===== Installing Ruby ====="
sudo pacman -S --noconfirm ruby
ruby -v

echo "===== Installing Flatpak ====="
sudo pacman -S --noconfirm flatpak

if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "===== All done! ====="
