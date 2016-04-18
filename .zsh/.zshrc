# completion settings
autoload -Uz compinit
compinit -u

# history settings
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export HISTCONTROL=ignoredups

# prompt
NAME_COLOR_FG="%{[38;5;031m%}"
NAME_COLOR_BG="%{[30;48;5;250m%}"
HOST_COLOR_FG="%{[38;5;062m%}"
AT_COLOR_FG="%{[38;5;100m%}"
TIME_COLOR_FG="%{[38;5;015m%}"
TIME_COLOR_BG="%{[30;48;5;012m%}"
COLOR_END="%{[0m%}"
PROMPT="${NAME_COLOR_BG}${NAME_COLOR_FG}%n ${AT_COLOR_FG}at ${HOST_COLOR_FG}%m ${TIME_COLOR_BG}${TIME_COLOR_FG} %T ${COLOR_END} %~
_> "

# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)
export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME=${JAVA8_HOME}
export M2_HOME=/usr/local/Cellar/maven/3.3.3/libexec
export M2=$M2_HOME/bin
export GRADLE_HOME=/usr/local/Cellar/gradle/2.4/libexec
export ANDROID_HOME=$HOME/android-sdk
export STUDIO_JDK=/Library/Java/JavaVirtualMachines/1.6.0.jdk

## golong
export GOPATH=$HOME/dev/eure/gopath1.5.3

export EDITOR='vi'
eval "$(direnv hook zsh)"
export SHELL='zsh'

export PATH=$PATH:${GOPATH}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/21.1.2:${ANDROID_HOME}/adb-peco/bin

## anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi

# alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
source ~/.tmuxinator/tmuxinator.zsh
