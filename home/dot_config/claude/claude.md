# Claude 設定

## Claudeとのやり取りルール

### 言語とコミュニケーション
- 特に指定がない限り、日本語でやり取りを行う
- 技術的な内容でも日本語で説明し、必要に応じて英語の専門用語を併記する
- 簡潔で分かりやすい説明を心がける
- 不明な点があれば遠慮なく質問する

### タスク実行の進め方
- 作業開始前に必ず計画を立て、ユーザーに確認を求める
- 複雑なタスクは小さなステップに分割する
- 各ステップの実行前に何を行うかを説明する
- 実行結果を報告し、次のステップに進む前に確認する

### コード作業時の原則
- 既存のコードスタイルと設定に従う
- 変更前に関連ファイルを確認し、影響範囲を把握する
- バックアップや版管理を活用してリスクを最小化する
- テストが存在する場合は必ず実行して動作確認する

### エラーハンドリング
- エラーが発生した場合は詳細な情報を提供する
- 問題の原因と解決策を明確に説明する
- 複数の解決案がある場合は選択肢を提示する
- 必要に応じて段階的なデバッグアプローチを提案する

## 一般的なルール

### コード品質
- プロジェクト内の既存のコードスタイルと規約に従う
- 意味のある変数名と関数名を使用する
- 不要な複雑さを避け、クリーンで読みやすいコードを書く
- 適切な場所でエラーハンドリングを含める
- 継承よりもコンポジションを優先する

### セキュリティのベストプラクティス
- シークレット、APIキー、パスワードをハードコードしない
- 機密設定には環境変数を使用する
- ユーザー入力を検証し、データをサニタイズする
- 最小権限の原則に従う
- 依存関係を最新に保つ

### ドキュメント
- 複雑なロジックには明確で簡潔なコメントを書く
- ドキュメントをコード変更と同期して更新する
- パブリックAPIには使用例を含める
- 前提条件と制限事項を文書化する

### テスト
- 新機能にはテストを書く
- 既存のテストカバレッジを維持する
- テスト内容を説明する記述的なテスト名を使用する
- エッジケースとエラー条件をテストする

### パフォーマンス
- 早期最適化を避ける
- 最適化前にプロファイリングを行う
- メモリ使用量とリソース管理を考慮する
- タスクに適切なデータ構造を使用する

### 協力
- 明確なコミットメッセージを書く
- 大きな変更は小さく焦点を絞ったコミットに分割する
- マージ前にコード変更をレビューする
- 前提条件と設計決定を伝える

### 開発ワークフロー
- バージョン管理を効果的に使用する
- ブランチを焦点を絞り短命に保つ
- プッシュ前にローカルで変更をテストする
- 確立されたブランチとマージ戦略に従う

## 言語固有のガイドライン

### 一般的なプログラミング
- 一貫したインデント（スペースまたはタブ、混在させない）を使用する
- 可能な限り深いネストを避ける
- nullと未定義値を適切に処理する
- コンテキストに適切なデータ型を使用する

### シェルスクリプト
- より良いエラーハンドリングのために `set -euo pipefail` を使用する
- 単語分割を防ぐために変数を引用符で囲む
- 静的解析に `shellcheck` を使用する
- 可読性のために長形式のフラグを優先する

### 設定ファイル
- 一貫したフォーマットと構造を使用する
- 複雑な設定を説明するコメントを含める
- 関連する設定をグループ化する
- デプロイ前に設定構文を検証する