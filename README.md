## Start

```
# clone
$ git clone https://github.com/futabooo/dotfiles.git

# oh-my-zsh
$ curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

$ cd dotfiles
$ git submodule init
$ git submodule update
$ sh setup.sh

## http://brew.sh
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
## https://github.com/Homebrew/homebrew-boneyard/
$ brew tap matsu-chara/brew-bundle
$ brew bundle

## ricty
$ cp -f /usr/local/Cellar/ricty/3.2.4/share/fonts/Ricty*.ttf ~/Library/Fonts/
$ fc-cache -vf
```
