# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="${ZSH_THEME:-robbyrussell}"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false" 

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(macos)


# gh-dash config
export GH_DASH_CONFIG="$HOME/dev-env/resources/gh-dash-config.yaml"

# Added by Windsurf
export PATH="/Users/andrewgreene/.codeium/windsurf/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# git aliases
alias ga='git add'
alias gc='git commit --verbose'
alias gco='git checkout'
alias glo='git log --oneline --decorate'
alias gst='git status --short --branch'

[[ -f ~/.aliases ]] && source ~/.aliases
