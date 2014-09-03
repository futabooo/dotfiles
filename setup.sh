#!/bin/bash

DOT_FILES=( .vim .vimrc .bash_profile .bashrc)

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
