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

# git auto complete (https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Zsh)
autoload -Uz compinit && compinit

export PATH=$PATH:$GOPATH:$GOBIN
source $HOME/.gvm/scripts/gvm

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

# export JAVA_HOME=$(/usr/libexec/java_home)
# export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
# export JAVA_15_HOME=$(/usr/libexec/java_home -v15)

# alias java8='export JAVA_HOME=$JAVA_8_HOME'
# alias java15='export JAVA_HOME=$JAVA_15_HOME'

export PATH=/usr/local/opt/gnupg@2.2/bin:$PATH

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias k=kubectl
alias tf=terraform


alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
source ~/.aliases

alias ide='open -na "GoLand.app" --args "$@"'
alias k-k3s='export KUBECONFIG=$HOME/.kube/k3s-home && echo $KUBECONFIG'

eval $(thefuck --alias)

# Nothing below here
source $ZSH/oh-my-zsh.sh

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

PROMPT='%{$fg[yellow]%}[%D{%L:%M:%S.%N}] %{$reset_color%}'$PROMPT
