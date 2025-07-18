# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="${ZSH_THEME:-robbyrussell}"

DISABLE_UPDATE_PROMPT="true" # autoupdate
ENABLE_CORRECTION="true" 
COMPLETION_WAITING_DOTS="true"
# plugins=()

export PATH="$PATH:$HOME/dev-env/bin"

source $ZSH/oh-my-zsh.sh

# git aliases
alias ga='git add'
alias gc='git commit --verbose'
alias gco='git checkout'
alias glo='git log --oneline --decorate'
alias gst='git status --short --branch'

alias zed="flatpak run dev.zed.Zed"

[[ -f ~/.aliases ]] && source ~/.aliases
