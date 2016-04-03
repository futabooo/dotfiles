# completion settings
autoload -Uz compinit
compinit -u

# history settings
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export HISTCONTROL=ignoredups

export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)
export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME=${JAVA8_HOME}
export M2_HOME=/usr/local/Cellar/maven/3.3.3/libexec
export M2=$M2_HOME/bin
export GRADLE_HOME=/usr/local/Cellar/gradle/2.4/libexec
export ANDROID_HOME=$HOME/android-sdk
export STUDIO_JDK=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk

## Ruby
export GEM_HOME=$HOME/.gems

## node
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

## golang
export GOPATH=$HOME/dev/gopath1.5.3
export GOROOT=/usr/local/go1.5.3
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH%

export EDITOR='vi'
export SHELL='zsh'

export PATH=$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/21.1.2:${ANDROID_HOME}/adb-peco/bin

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
source ~/.tmuxinator/tmuxinator.zsh
