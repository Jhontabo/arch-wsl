#! /bin/bash
set -e

echo "===== Updating system ====="
sudo apt update && sudo apt upgrade -y

echo "===== Installing base packages ====="
BASIC_PACKAGES=(
  zsh htop btop cmatrix cava
  gcc fzf ripgrep fd-find unzip vlc
  python3 python3-pip
)

for pkg in "${BASIC_PACKAGES[@]}"; do
  sudo apt install -y "$pkg" || echo "Warning: Failed to install $pkg, continuing..."
done

# fd is usually already included in Linux Mint

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

echo "===== Installing Java (OpenJDK 21 or available) ====="
sudo apt install -y openjdk-21-jdk openjdk-21-jre

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

rustc --version 2>/dev/null ||
  (
    echo "Installing Rust…" &&
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &&
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

echo "===== Installing Flatpak software ====="
FLATPAK_APPS=(
  org.onlyoffice.desktopeditors
  com.rtosta.zapzap
  org.apache.netbeans
  md.obsidian.Obsidian
  org.telegram.desktop
  com.getpostman.Postman
  com.google.Chrome
  com.spotify.Client
  org.gimp.GIMP
  com.anydesk.Anydesk
  io.dbeaver.DBeaverCommunity
  org.filezillaproject.Filezilla
  net.ankiweb.Anki
  com.visualstudio.code
  com.obsproject.Studio
  com.sindresorhus.Caprine
)

for app in "${FLATPAK_APPS[@]}"; do
  flatpak install -y flathub "$app" ||
    echo "Warning: Failed to install $app"
done

echo "===== All done! ====="
