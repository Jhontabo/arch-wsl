#! /bin/bash
set -e

echo "===== Updating system ====="
sudo apt update && sudo apt upgrade -y

echo "===== Installing base packages ====="
BASIC_PACKAGES=(
  tree kitty zsh htop btop cmatrix cava
  gcc fzf ripgrep fd-find unzip vlc
  python3 python3-pip
)

for pkg in "${BASIC_PACKAGES[@]}"; do
  sudo apt install -y "$pkg" || echo "Warning: Failed to install $pkg, continuing..."
done

echo "===== Installing PHP ====="
PHP_PACKAGES=(
  php php-cli php-mbstring php-xml php-json php-curl php-zip php-gd
)
for pkg in "${PHP_PACKAGES[@]}"; do
  sudo apt install -y "$pkg" || echo "Warning: Failed to install $pkg"
done

echo "===== Installing Node.js and npm ====="
sudo apt install -y nodejs npm || echo "Warning: Failed to install Node.js or npm"

echo "===== Installing MariaDB ====="
sudo apt install -y mariadb-server mariadb-client || echo "Warning: Failed to install MariaDB"

sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "===== Installing Java (OpenJDK 24 or available) ====="
sudo apt install -y openjdk-18-jdk openjdk-21-jre

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

rustc --version 5>/dev/null ||
  (
    echo "Installing Rust…" &&
      curl --proto '=https' --tlsv4.2 -sSf https://sh.rustup.rs | sh -s -- -y &&
      export PATH="$HOME/.cargo/bin:$PATH" &&
      rustc --version
  )

echo "===== Installing Ruby ====="
sudo apt install -y ruby-full
ruby -v

# Flatpak
echo "===== Installing Flatpak ====="
sudo apt install -y flatpak

if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "===== All done! ====="
