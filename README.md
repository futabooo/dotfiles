## Start

```
## clone
$ git clone https://github.com/futabooo/dotfiles.git
$ cd dotfiles

## init submodules
## https://github.com/Shougo/neobundle.vim
$ git submodule init
$ git submodule update

## setup
$ sh setup.sh

### change login shell
$ sudo vi /etc/shells
add `/usr/local/bin/zsh`
$ chsh -s /usr/local/bin/zsh

### install anyenv
### https://github.com/riywo/anyenv
$ cd
$ git clone https://github.com/riywo/anyenv ~/.anyenv
$ anyenv install rbenv
$ anyenv install ndenv
$ anyenv install goenv

### install tmuxinator
### https://github.com/tmuxinator/tmuxinator
$ cd
$ mkdir .tmuxinator
$ cd .tmuxinator
$ wget https://raw.github.com/aziz/tmuxinator/master/completion/tmuxinator.zsh

## ricty
$ brew install --vim-powerline ricty
$ cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
$ fc-cache -vf

## adb-peco
$ gem install adb-peco

### Create Ricty for powerline
http://qiita.com/jpshadowapps/items/d4178daf45c99e653996
