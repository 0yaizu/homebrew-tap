# homebrew-tap

[ClaudeGauge](https://github.com/0yaizu/claudegauge)を、Homebrewで入れるためのtapです。

## インストール

```sh
brew install --cask 0yaizu/tap/claudegauge
```

## 更新

```sh
brew upgrade --cask claudegauge
```

## 注意

- 非公式のアプリで、Anthropic社のClaudeとは無関係です。自己責任で使用してください。
- アプリは公証(notarization)していません。初回の起動では、「システム設定 > プライバシーとセキュリティ」で「このまま開く」を押します。
- 対象は、Apple Silicon、macOS26以降です。

## 更新の仕組み

`.github/workflows/bump.yml`が6時間おきに本体の最新の安定版(`v1.2.3`の形)を調べ、新しければ`Casks/claudegauge.rb`を更新するPRを作ります。pre-releaseは対象外です。
