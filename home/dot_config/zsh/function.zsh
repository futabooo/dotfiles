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