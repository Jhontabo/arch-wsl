# Enable Powerlevel10k instant prompt. Should stay close to the top o# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Extensiones del PATH
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded
ZSH_THEME="robbyrussell"

cowsay -f tux "¡Welcome, $(whoami)!"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# HYPHEN_INSENSITIVE="true

# Alias git

alias gs='git status'
alias gss='git status -s'
alias gcm='git commit -m'

alias gca='git commit --amend' 
alias gcam='git commit --amend -m' 

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gco='git checkout'
alias gcob='git checkout -b'

alias gl='git log'
alias glp='git log --pretty=oneline'
alias glg='git log --graph --oneline --all' 
alias gd='git diff'
alias gds='git diff --staged'

alias ga='git add'
alias gaa='git add --all'

alias gp='git push'
alias gpo='git push origin'
alias gpu='git pull'
alias gpur='git pull --rebase'
alias gf='git fetch'

alias gst='git stash'
alias gsp='git stash pop'
alias gsl='git stash list' 

alias gr='git reset'
alias grh='git reset --hard' 
alias gcl='git clone'
alias gcp='git cherry-pick'
alias grb='git rebase'

## fedora
alias update='sudo dnf update -y'
alias upgrade='sudo dnf upgrade -y'
alias fast='fastfetch'
alias nvimconfig='nvim ~/.config/nvim'


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

