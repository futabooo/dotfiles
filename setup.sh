#!/bin/bash

# install oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# set oh-my-zsh theme
THEME=solarized-powerline.zsh-theme
ln -s $HOME/dotfiles/.zsh/oh-my-zsh-solarized-powerline-theme/$THEME $HOME/.oh-my-zsh/themes

# create dotfiles symbolic link
DOT_FILES=( .vim .vimrc .gitconfig .bash_profile .bashrc .zshrc)

for file in ${DOT_FILES[@]}
do
  if [ -a $HOME/$file ]; then
    echo "既にファイルが存在します: $file"
  else
    ln -s $HOME/dotfiles/$file $HOME/$file
	echo "シンボリックリンクをはりました: $file"
  fi
done

# ターミナルの不可視項目を表示
defaults write com.apple.finder AppleShowAllFiles -boolean true

# brew bundle
brew tap homebrew/boneyard
