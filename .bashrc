#この設定ではログイン時の/usr/local/binの重複を防げなかったので、/etc/pathsの順番変更する
# /usr/local/bin moved to first if brew command installed
#brew=/usr/local/bin
#type brew >/dev/null 2>&1 && export PATH=$brew:${PATH//$brew:/}

export M2_HOME=/usr/local/Cellar/maven/3.2.1/libexec
export M2=$M2_HOME/bin
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

