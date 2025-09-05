# Enable Powerlevel12k instant prompt. Should stay close to the top o# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Extensiones del PATH
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded
ZSH_THEME="robbyrussell"

# Cowsay 

cowsay -f tux "¡Welcome, Jhontabo!"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# HYPHEN_INSENSITIVE="true


# Arch

alias up='sudo pacman -Syu'
alias fast='fastfetch'
alias matrix='cmatrix'

## Laravel

alias pas='php artisan serve'
alias dev='npm run dev'
alias build='npm run build'
alias migrate='php artisan migrate'
alias seed='php artisan migrate --seed'
alias tst='php artisan test'
alias cache='php artisan config:cache'
alias fresh='php artisan migrate:fresh'

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
