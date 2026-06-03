<!-- リポジトリの目的、構成、運用方法を短く案内します。 -->
# 技術質問ノート

Codexと一緒に、技術的な疑問を静的HTMLの記事として蓄積するためのリポジトリです。

## 構成

```text
notes-ChatGPT/
├── .github/workflows/static.yml
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
