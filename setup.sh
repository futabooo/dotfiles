#!/bin/bash

# create dotfiles symbolic link
DOT_FILES=( .asdfrc .vim .vimrc .gitconfig .bash_profile .bashrc .zsh .zshenv .tool-versions)

for file in ${DOT_FILES[@]}
do
  if [ -a $HOME/$file ]; then
    echo "既にファイルが存在します: $file"
  else
    ln -s $HOME/dotfiles/$file $HOME/$file
	echo "シンボリックリンクをはりました: $file"
  fi
done

ln -s $HOME/dotfiles/sheldon/plugins.toml $HOME/.config/sheldon/plugins.toml

# show invisible item of Terminal
defaults write com.apple.finder AppleShowAllFiles -boolean true

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
