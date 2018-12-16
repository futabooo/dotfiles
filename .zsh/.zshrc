## Command history configuration
#
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
# ignore duplication command history list
setopt hist_ignore_all_dups
# share command history data
setopt share_history
# auto directory pushd that you can get dirs list by 'cd -[tab]'
setopt auto_pushd
# igonre duplication dir list
setopt pushd_ignore_dups

## Default shell configuration
#
# set prompt
NAME_COLOR_FG="%{[38;5;031m%}"
NAME_COLOR_BG="%{[30;48;5;250m%}"
HOST_COLOR_FG="%{[38;5;062m%}"
AT_COLOR_FG="%{[38;5;100m%}"
TIME_COLOR_FG="%{[38;5;015m%}"
TIME_COLOR_BG="%{[30;48;5;012m%}"
SUCCES_COLOR="%{[38;5;040m%}"
FALSE_COLOR="%{[38;5;033m%}"
SUGGEST_COLOR="%{[38;5;001m%}"
COLOR_END="%{[0m%}"
PROMPT="${NAME_COLOR_BG}${NAME_COLOR_FG}%n ${AT_COLOR_FG}at ${HOST_COLOR_FG}%m ${TIME_COLOR_BG}${TIME_COLOR_FG} %T ${COLOR_END} %~
%(?.${SUCCES_COLOR}.${FALSE_COLOR})%(?!(*'-') <!(*;-;%)? <) ${COLOR_END} "
PROMPT2="[%n]>"
SPROMPT="${SUGGEST_COLOR}${suggest}(*'~'%)? < もしかして%B%r%b ${SUGGEST_COLOR}かな? [そう!(y), 違う!(n),a,e]:${COLOR_END} "
# set ls color
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# completion configuration 
autoload -U compinit
compinit
# auto change directory
setopt auto_cd
# command correct edition before aech completion attempt
setopt correct
# no remove postfix slash of command line
setopt noautoremoveslash
# use a regular expression of PCRE compatible
setopt re_match_pcre
# select completion with the cursor keys
zstyle ':completion:*:default' menu select=2

## for fastlane
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

## vcs_info
#
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

## Environment variable configuration
#
export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)
export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME=${JAVA8_HOME}
export ANDROID_HOME=$HOME/android
export GOPATH=$HOME/dev

export EDITOR='vi'
eval "$(direnv hook zsh)"
export SHELL='zsh'

export PATH=$PATH:${GOPATH}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  for D in `ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

## Alias configuration
#
alias ls='ls -G'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ij='open -b com.jetbrains.intellij'
alias adb='adb-peco'

## Function configuration
#
function echoColors() {
  for c in {000..255};do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
}

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

function peco-select-history() {
  BUFFER=$(history -n 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## tmuxinator
source ~/.tmuxinator/tmuxinator.zsh
