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

本体の安定版(`v1.2.3`の形)のリリースが終わると、本体の`release.yml`が`.github/workflows/bump.yml`を起動します。`bump.yml`は、本体のリリースのzipが、そのタグのコミットから本体の`release.yml`でビルドされたものか、由来の証明(attestation)で検証します。検証したzipからsha256を計算して、`Casks/claudegauge.rb`の`version`と`sha256`を更新して、`main`に直接pushします。取りこぼしに備えて、6時間おきにも動きます。pre-releaseは対象外です。
