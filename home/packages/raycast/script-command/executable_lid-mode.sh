#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title フタ閉じ作業モード
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 💻

# Documentation:
# @raycast.description フタを閉じてもスリープしない設定をトグルする。ONにしたらそのままロック画面へ切り替える。

set -u

PMSET=/usr/bin/pmset
CGSESSION="/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession"

lock_screen() {
  if [ -x "$CGSESSION" ]; then
    "$CGSESSION" -suspend
  else
    # CGSession が無い環境向けのフォールバック (Ctrl+Cmd+Q)
    # Raycast に「アクセシビリティ」と「システムイベント」の許可が必要
    osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
  fi
}

if [ "$("$PMSET" -g | awk '/SleepDisabled/ { print $2; exit }')" = "1" ]; then
  target=0
else
  target=1
fi

if ! sudo -n "$PMSET" -a disablesleep "$target" 2>/dev/null; then
  echo "⚠️ sudo がパスワードを要求しました。/etc/sudoers.d/pmset を設定してください"
  exit 1
fi

if [ "$target" = "1" ]; then
  echo "🔒 フタ閉じOK — ロックします"
  sleep 1
  lock_screen
else
  echo "🌙 通常モードに戻しました"
fi
