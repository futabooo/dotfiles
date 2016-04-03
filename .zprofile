## Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

source ~/.tmuxinator/tmuxinator.zsh
eval "$(direnv hook zsh)"
