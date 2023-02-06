# OS Specific setup
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     export PATH=$PATH:~/.linuxbrew/bin
                ;;
    Darwin*)    export PATH=$PATH:~/dev-env/osx/bin:~/dev-env/bin:~/.tmux/plugins/tpm
                ;;
    *)          echo "UNKNOWN:${unameOut} not adding bin folder"
esac

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="half-life"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=( git kubectl macos )

function preexec() {
    typeset -gi CALCTIME=1
    typeset -gi CMDSTARTTIME=SECONDS
}
function precmd() {
    if (( CALCTIME )) ; then
        typeset -gi ETIME=SECONDS-CMDSTARTTIME
        EXEC_TIME="took $ETIME s"
    fi
    typeset -gi CALCTIME=0
}

# User configuration
export K9S_HOME=$HOME/Library/Preferences/k9s

# git auto complete (https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Zsh)
autoload -Uz compinit && compinit

 . /opt/homebrew/opt/asdf/libexec/asdf.sh

export PATH=$PATH:$GOPATH:$GOBIN
source $HOME/.gvm/scripts/gvm

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# https://cloud.google.com/sdk/docs/install-sdk
export PATH=$PATH:/usr/local/opt/google-cloud-sdk/bin
export PATH=/opt/homebrew/opt/gnupg@2.2/bin:$PATH

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias k=kubectl
alias tf=terraform

PROMPT_UPDATE='%{$fg[yellow]%}[%D{%L:%M:%S.%N}] %{$reset_color%}'
alias enable-time-prompt='export PROMPT=$PROMPT_UPDATE$PROMPT'
alias disable-time-prompt='source ~/.zshrc' #lol-cmd-amirit
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias zda='zarf destroy --confirm --remove-components'
alias virtctl=/usr/local/bin/virtctl-v0.58.0
alias k9s='k9s --headless'

source ~/.aliases

# Nothing below here
source $ZSH/oh-my-zsh.sh

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
