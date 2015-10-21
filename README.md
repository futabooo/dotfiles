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

## install homebrew
## http://brew.sh
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

## El Capitan
## install to /opt
$ cd /opt
$ sudo mkdir homebrew
$ sudo chown ${USER}:staff homebrew
$ curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C homebrew
# Add /opt/homebrew/bin to /etc/paths

## https://github.com/Homebrew/homebrew-boneyard/
$ brew tap matsu-chara/brew-bundle
$ brew bundle

## ricty
#$ cp -f /usr/local/Cellar/ricty/3.2.4/share/fonts/Ricty*.ttf ~/Library/Fonts/
#$ fc-cache -vf
$ brew tap sanemat/font
$ brew install --vim-powerline ricty
$ cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
$ fc-cache -vf
```

## adb-peco
$ cd $ANDROID_HOME
$ git clone https://github.com/tomorrowkey/adb-peco.git

### Create Ricty for powerline
http://qiita.com/jpshadowapps/items/d4178daf45c99e653996
