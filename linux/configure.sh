#!/bin/bash
# Delta's between this and ../configure.sh
#   - bash
#   - sudo apt-get install build-essential procps curl file git zsh -y
#   - brew install for linux
#   - asdf plugins, dont' need to check for ~/.asdf dir
#   - gsd binary pathing

asdf_plugin() {
  # Check for asdf plugin and install if not present
  local name=$1
  local url=$2
  if ! `asdf plugin list | grep -q "$name"`; then
    echo "...adding $name"
    asdf plugin add "$name" "$url"
  else
    echo "...$name already installed"
  fi
}

if [[ `uname` != "Linux" ]]; then
  echo "Unsupported operating system"
  exit 1;
fi

script_path="$( cd "$(dirname "$0")" ; pwd -P)"

echo "Checking for Homebrew..."
which brew >/dev/null
brew_inst=`echo $?`
if [[ $brew_inst == 1 ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/home/andrew/.linuxbrew/bin/brew shellenv)"') >> /home/andrew/.zshrc
  eval "$(/home/andrew/.linuxbrew/bin/brew shellenv)"
else
  echo  "...Homebrew already installed"
fi

echo "Updating using Homebrew..."
./run-brew.sh

### Workarounds :(
# Chrome on Linux
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

wget https://downloads.slack-edge.com/desktop-releases/linux/x64/4.39.88/slack-desktop-4.39.88-amd64.deb
sudo dpkg -i slack-desktop-4.39.88-amd64.deb

rm -rf *.deb

echo "Checking for oh-my-zsh..."
if [[ ! -a ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "...oh-my-zsh already installed"
fi

echo "Checking for tmux plugins..."
tmux_plugins_dir=~/.tmux/plugins/tpm
if [[ ! -a ~/.tmux ]]; then
    mkdir -p $tmux_plugins_dir
    git clone https://github.com/tmux-plugins/tpm $tmux_plugins_dir
else
    echo "...updating"
    cd $tmux_plugins_dir && git pull -r
    cd - >/dev/null
fi

asdf_plugin golang https://github.com/kennyp/asdf-golang.git
asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git

echo "Setting dotfile/s..."
rm ~/.zshrc ~/.aliases ~/.config/alacritty/alacritty.toml ~/.tmux.conf ~/.hammerspoon/init.lua
# TODO - Allacrity brew didn't install... mkdir -p ~/.config/alacritty
# TODO - hammerspon dne on linux, i3 instead?... mkdir -p ~/.hammerspoon/
cd ..
./bin/gsd_linux configure # Use GSD to set links
cd -

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/andrew/.zshrc

sed -i 's|\. /opt/homebrew/opt/asdf/libexec/asdf.sh|\. /home/linuxbrew/.linuxbrew/Cellar/asdf/0.14.0/libexec/asdf.sh|' ~/.zshrc
/home/linuxbrew/.linuxbrew/Cellar/asdf/0.14.0/libexec/asdf.sh

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


echo "Happy Developing!!!"
