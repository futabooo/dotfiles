#この設定ではログイン時の/usr/local/binの重複を防げなかったので、/etc/pathsの順番変更する
# /usr/local/bin moved to first if brew command installed
#brew=/usr/local/bin
#type brew >/dev/null 2>&1 && export PATH=$brew:${PATH//$brew:/}

export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.7"`
export M2_HOME=/usr/local/Cellar/maven/3.2.2/libexec
export M2=$M2_HOME/bin
export GRADLE_HOME=/usr/local/Cellar/gradle/2.0/libexec
export ANDROID_HOME=$HOME/android-sdk
export STUDIO_JDK=/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk
export PATH=$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

export PATH=$PATH:$HOME/gsutil

export HISTSIZE=2000
export HISTCONTROL=ignoredups


alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
