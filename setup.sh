#!/bin/bash

# create dotfiles symbolic link
DOT_FILES=( .ssh .vim .vimrc .gitconfig .bash_profile .bashrc .zsh .zshenv .tool-versions)

for file in ${DOT_FILES[@]}
do
  if [ -a $HOME/$file ]; then
    echo "既にファイルが存在します: $file"
  else
    ln -s $HOME/dotfiles/$file $HOME/$file
	echo "シンボリックリンクをはりました: $file"
  fi
done

# show invisible item of Terminal
defaults write com.apple.finder AppleShowAllFiles -boolean true

# install homebrew
# https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/El_Capitan_and_Homebrew.md
if [ -a /usr/local ]; then
  sudo chown -R $(whoami):admin /usr/local
else
  sudo mkdir /usr/local && sudo chflags norestricted /usr/local && sudo chown -R $(whoami):admin /usr/local
fi
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
