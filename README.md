<!-- リポジトリの目的、構成、運用方法を短く案内します。 -->
# 技術質問ノート

Codexと一緒に、技術的な疑問を静的HTMLの記事として蓄積するためのリポジトリです。

## 構成

```text
notes-ChatGPT/
├── .github/workflows/static.yml
├── scripts/publish.ps1
├── styles/site.css
├── images/
├── guides/
├── index.html
├── AGENTS.md
└── README.md
```

## 運用

1. 「質問」で始まる依頼から、CodexがHTML記事を作成します。
2. 記事はカテゴリ別ディレクトリに `index.html` として追加します。
3. トップページの `index.html` に記事カードを追加します。
4. 公開前に差分、参照URL、秘匿情報の混入有無を確認します。

GitHub Pagesで公開する場合は、リポジトリ設定の Pages で Source を GitHub Actions に設定してください。

## 公開作業の自動化

次のコマンドで `git add`、`git commit`、`git push` をまとめて実行できます。

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish.ps1
```

コミットメッセージを指定したい場合は、`-Message` を付けます。

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish.ps1 -Message "Add note about TripoSplat"
```

VS Codeから実行する場合は、`Ctrl+Shift+P` で `Tasks: Run Task` を選び、`Publish notes` を実行します。
コミットメッセージを指定したい場合は、`Publish notes with message` を選びます。

直近の公開を取り下げる場合は、履歴を書き換えずにrevertコミットを作ってpushします。

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\revert-latest.ps1
```

## 参考にした記事

このリポジトリ作成の参考として、以下の記事を参照しました。

- t.taniguchi, "Instant Question HTML Notes" (Zenn): https://zenn.dev/ttaniguchi/articles/instant-question-html-notes
