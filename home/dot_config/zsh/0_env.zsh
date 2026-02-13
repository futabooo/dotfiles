# sheldon/plugins.tomlのdotfiles-syncで読み込まれる.zshファイルの中で
# 一番最初に読み込まれたいので0をファイル名につける

## options
### ignore duplication command history list
setopt hist_ignore_all_dups
### share command history data
setopt share_history
### auto directory pushd that you can get dirs list by 'cd -[tab]'
setopt auto_pushd
### history list duplicates an older one, the older command is removed from the list
setopt hist_ignore_all_dups
### igonre duplication dir list
setopt pushd_ignore_dups
### command correct edition before each completion attempt
setopt correct
### no remove postfix slash of command line
setopt noautoremoveslash
### use a regular expression of PCRE compatible
setopt re_match_pcre
### no beep
setopt nolistbeep
### add timestamp zsh history file
setopt extended_history
### select completion with the cursor keys
zstyle ':completion:*:default' menu select=2

## color
export CLICOLOR=1
export TERM=xterm-256color

## history
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

## java
export JAVA17_HOME=$(/usr/libexec/java_home -v 17)
export JAVA21_HOME=$(/usr/libexec/java_home -v 21)
export JAVA24_HOME=$(/usr/libexec/java_home -v 24)
export JAVA_HOME=${JAVA17_HOME}

## android
export ANDROID_HOME=$HOME/android

## dart
export DART_PUB=$HOME/.pub-cache

## go
export GOENV_DISABLE_GOPATH=1
export GOPATH=$HOME/dev

export LANG=en_US.UTF-8

## other 
export EDITOR='vi'
export SHELL='zsh'

## path
export PATH=${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$HOME/.cargo/bin:${GOPATH}/bin:${ANDROID_HOME}/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${DART_PUB}/bin:$PATH

## asdf
export ASDF_CONFIG_FILE=${XDG_CONFIG_HOME}/asdf/asdfrc

## google-cloud-sdk
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

## starship
export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/starship.toml