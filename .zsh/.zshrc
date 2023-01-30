# zinit install {{{
if [[ ! -f $HOME/.zsh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zsh/.zinit" && command chmod g-rwX "$HOME/.zsh/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zsh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zsh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}}

# zinit basic plugins {{{
zinit wait lucid blockf light-mode for \
  @'zsh-users/zsh-autosuggestions' \
  @'zsh-users/zsh-completions' \
  @'zdharma-continuum/fast-syntax-highlighting'
# }}}

# zsh options {{{
## color
export CLICOLOR=1
export TERM=xterm-256color

## history
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
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

## completion
fpath=($HOME/.zsh/Completion ${fpath})
autoload -Uz compinit && compinit
autoload -Uz _gx
### command correct edition before each completion attempt
setopt correct
### no remove postfix slash of command line
setopt noautoremoveslash
### use a regular expression of PCRE compatible
setopt re_match_pcre
### no beep
setopt nolistbeep
### select completion with the cursor keys
zstyle ':completion:*:default' menu select=2
# }}}

# environment variables {{{
## java
export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)
export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA11_HOME=$(/usr/libexec/java_home -v 11)
export JAVA15_HOME=$(/usr/libexec/java_home -v 15)
export JAVA_HOME=${JAVA11_HOME}
## android
export ANDROID_HOME=$HOME/android
## go
export GOENV_DISABLE_GOPATH=1
export GOPATH=$HOME/dev
## fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
## other 
export EDITOR='vi'
export SHELL='zsh'
## path
export PATH=$PATH:${GOPATH}/bin:${ANDROID_HOME}/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

## homebrew
export HOMEBREW_HOME="/opt/homebrew"
export PATH=${HOMEBREW_HOME}/bin:${HOMEBREW_HOME}/sbin:$PATH

## asdf
if [[ -f ${HOMEBREW_HOME}/opt/asdf/libexec/asdf.sh ]]; then
  source ${HOMEBREW_HOME}/opt/asdf/libexec/asdf.sh
fi
export ASDF_CONFIG_FILE=$HOME/dotfiles/.asdfrc

## kubectl
source <(kubectl completion zsh)

## google-cloud-sdk from homebrew 
source "${HOMEBREW_HOME}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "${HOMEBREW_HOME}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# }}}

## direnv
eval "$(direnv hook zsh)"

## alias {{{
alias la='ls -la'
alias ll='ls -lG'
alias ls='ls -G'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ij='open -b com.jetbrains.intellij'
alias adb='adb-peco'
alias emulator='${ANDROID_HOME}/tools/emulator'
alias k=kubectl
# }}}

# function {{{
## ghqとpecoでリポジトリ検索
function peco-src() {
  local dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$dir" ]; then
    BUFFER="cd $GOPATH/src/$dir"
	zle accept-line
  fi
  zle -R -c
}
zle -N peco-src
bindkey '^]' peco-src

## pecoで履歴検索
function peco-select-history() {
  BUFFER=$(history -n 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## gcloud のアクティブな設定を切り替える
function gcloud-activate() {
  name="$1"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
## gcloud configurationsからpecoで切り替え
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | peco)
    name=$(echo "${line}" | awk '{print $1}')
  else
    line=$(gcloud config configurations list | grep "$name")
  fi
  gcloud-activate "${name}"
}
function gcloud-current() {
    cat $HOME/.config/gcloud/active_config
}
# }}}

# prompt {{{
export STARSHIP_CONFIG=$HOME/dotfiles/starship//starship.toml
eval "$(starship init zsh)"
# }}}

