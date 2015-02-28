#!/bin/bash

DOT_FILES=( .vim .vimrc .gitconfig .bash_profile .bashrc)

for file in ${DOT_FILES[@]}
do
  if [ -a $HOME/$file ]; then
    echo "既にファイルが存在します: $file"
  else
    ln -s $HOME/dotfiles/$file $HOME/$file
	echo "シンボリックリンクをはりました: $file"
  fi
done

# oh-my-zshのテーマを設定
THEME=solarized-powerline.zsh-theme
ln -s $HOME/dotfiles/oh-my-zsh-solarized-powerline-theme/$THEME $HOME/.oh-my-zsh/themes

# ターミナルの不可視項目を表示
defaults write com.apple.finder AppleShowAllFiles -boolean true

# brew bundle
brew tap homebrew/boneyard
