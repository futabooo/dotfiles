# Raycast

## script-command

`chezmoi apply` で `~/packages/raycast/script-command/` に配置される。Raycast の Extensions → Script Commands → Add Script Directory でこのパスを指定する。

ソースディレクトリを直接指定しないこと。ソース側はファイル名が chezmoi の属性プレフィックス付き（`executable_`）になっていて、将来テンプレート（`.tmpl`）を使うとファイル名も中身も配置後のものと一致しなくなる。

**新しいスクリプトを追加するときは必ず `executable_` プレフィックスを付ける。** これが無いと配置先で実行ビットが落ちて Raycast から実行できない。

### executable_obsidian_add_times.sh

分報をObsidianのデイリーノートに追記する。

### executable_lid-mode.sh

フタを閉じても作業が止まらないモードのトグル。ONにすると `pmset -a disablesleep 1` でスリープを無効化し、そのままロック画面に切り替える。もう一度叩くと `disablesleep 0` に戻す。

事前にパスワードなしで `pmset` を叩けるようにしておく（`yourname` は `whoami` の結果に置き換え）:

```bash
sudo visudo -f /etc/sudoers.d/pmset
```

```
yourname ALL=(ALL) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1
```

Raycastのスクリプトはパスワードプロンプトを出せないので、sudoが対話を求めた場合はスクリプト側でエラーを表示して終了する。

注意点:

- 電源に繋がずフタを閉じたまま放置するとバッテリーを消費し続けるので、カバンに入れる前に必ず通常モードへ戻す
- `CGSession -suspend` が無い環境ではCtrl+Cmd+QのAppleScriptにフォールバックする。その場合はRaycastにアクセシビリティ権限が必要
