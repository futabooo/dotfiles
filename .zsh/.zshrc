# zinit install {{{
if [[ ! -f $HOME/.zsh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zsh/.zinit" && command chmod g-rwX "$HOME/.zsh/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zsh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zsh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}}

# zinit basic plugins {{{
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
# }}}

# prompt {{{
zinit ice lucid atload'!_zsh_git_prompt_precmd_hook' 
zinit load woefe/git-prompt.zsh

ZSH_GIT_PROMPT_FORCE_BLANK=1
ZSH_GIT_PROMPT_SHOW_UPSTREAM="full"

ZSH_THEME_GIT_PROMPT_PREFIX="%B · %b"
ZSH_THEME_GIT_PROMPT_SUFFIX="›"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" ‹"
ZSH_THEME_GIT_PROMPT_BRANCH="⎇ %{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[yellow]%} ⤳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_no_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_no_bold[cyan]%}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_no_bold[cyan]%}↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

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
KAO_1="(*'-'%)"
KAO_2="(*;-;%)"
KAO_3="(*'~'%)?"

PROMPT=$'${NAME_COLOR_BG}${NAME_COLOR_FG} %n ${AT_COLOR_FG}at ${HOST_COLOR_FG}%m ${TIME_COLOR_BG}${TIME_COLOR_FG} %T ${COLOR_END} %(?..%F{red}%?%f · ) %B%~%b$(gitprompt)\n%(?.${SUCCES_COLOR}.${FALSE_COLOR})%(?!${KAO_1} <!${KAO_2} <) ${COLOR_END} '
RPROMPT=''
SPROMPT='${SUGGEST_COLOR}${suggest}${KAO_3} < もしかして%B%r%b ${SUGGEST_COLOR}かな? [そう!(y), 違う!(n),a,e]:${COLOR_END} '
# }}}

# zsh options {{{
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
autoload -Uz compinit && compinit
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

## asdf
if [[ -f /usr/local/opt/asdf/libexec/asdf.sh ]]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
fi
export ASDF_CONFIG_FILE=$HOME/dotfiles/.asdfrc

## direnv
eval "$(direnv hook zsh)"

## homebrew
export PATH="/usr/local/sbin:$PATH"

## tmuxinator
source ~/.tmuxinator/tmuxinator.zsh

## kubectl
### see https://github.com/zdharma/zinit/issues/174 
source <(kubectl completion zsh)
zinit ice as"completion"
zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh

## google-cloud-sdk from homebrew 
export CLOUDSDK_PYTHON="/usr/local/opt/python@3.8/libexec/bin/python"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
# }}}

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
# }}}

