#! /bin/sh

mkdir -p $XDG_CONFIG_HOME/ghostty
rm -rf $XDG_CONFIG_HOME/ghostty/config
ln -s /var/home/andrew/dev-env/linux/resources/ghostty/config $XDG_CONFIG_HOME/ghostty/config

rm -rf $HOME/.zshrc
ln -s /var/home/andrew/dev-env/linux/resources/.zshrc $HOME/.zshrc

rm -rf $HOME/.gitconfig
ln -s /var/home/andrew/dev-env/resources/.gitconfig $HOME/.gitconfig