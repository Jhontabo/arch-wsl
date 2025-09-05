# 🛠️ Dotfiles

Welcome to my personal **dotfiles** repository. These configurations define my Linux development environment — designed for productivity, minimalism, and customization.

> ⚙️ Tested primarily on **Arch in WSL (Windows Subsystem for Linux)**

---

## 📦 What's Included

- **Zsh** configuration with custom aliases and enhancements (`.zshrc`)
- **Automated setup script** to apply all configurations (`ubuntu-wsl.sh`)

---

## 🚀 Installation (WSL)

> ⚠️ Warning: This will overwrite some of your current settings. Make sure to back up your existing configs if needed.

```bash
git clone https://github.com/Jhontabo/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
chmod +x script.sh
./ubuntu-wsl.sh
