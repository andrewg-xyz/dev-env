#!/bin/sh

if [[ `uname` != "Darwin" ]]; then
  echo "Unsupported operating system"
  exit 1;
fi

script_path="$( cd "$(dirname "$0")" ; pwd -P)"

echo "Checking for Homebrew..."
which brew >/dev/null
brew_inst=`echo $?`
if [[ $brew_inst == 1 ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/andrewgreene/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/andrewgreene/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo  "...Homebrew already installed"
fi

echo "Updating using Homebrew..."
cd $script_path/osx
./run-brew.sh
cd - >/dev/null

echo "Checking for oh-my-zsh..."
if [[ ! -a ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "...oh-my-zsh already installed"
fi

echo "Setting dotfile/s..."
rm ~/.zshrc ~/.aliases ~/.wezterm.lua ~/.hammerspoon/init.lua
mkdir -p ~/.hammerspoon/
$script_path/bin/gsd configure # Use GSD to set links

echo "Updating /etc/hosts and ssh config..."
if [[ ! -a ~/dev-env/resources/buzzbert/hosts && ! -e ~/dev-env/resources/buzzbert/config ]]; then
    echo "...No host and config file found. not making life better"
else
    echo "...Updating Hosts file"
    head="### BEGIN GENERATED CONTENT (unique-spiderman)"
    tail="### END GENERATED CONTENT"
    newContent=`cat resources/buzzbert/hosts`
    sudo sed -i.bak "/$head/,/$tail/d" /etc/hosts
    echo "...Adding custom configuration"
    newContent="$head\n$newContent\n$tail"
    echo $newContent | sudo tee -a /etc/hosts
    echo "Updating SSH Config..."
    cp -f resources/buzzbert/config ~/.ssh/config
fi

echo "\nHappy Developing!!!"
