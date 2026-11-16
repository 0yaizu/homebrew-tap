#!/bin/bash
# 本体リポジトリの最新の安定版を見て、cask の version と sha256 を書き換える。
# 変わったときだけ、変更後の version を標準出力に出す (変わらなければ何も出さない)。
set -euo pipefail

cd "$(dirname "$0")/.."

APP_REPO="0yaizu/claudegauge"
CASK="Casks/claudegauge.rb"

# gh の "latest" は pre-release とドラフトを含まない。
tag="$(gh release view --repo "$APP_REPO" --json tagName --jq .tagName)"
if [[ ! "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "安定版のタグの形ではありません: $tag" >&2
    exit 1
fi
version="${tag#v}"

current="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$CASK")"
[[ "$version" != "$current" ]] || exit 0

sha="$(gh release download "$tag" --repo "$APP_REPO" --pattern "ClaudeGauge-$tag.zip.sha256" -O - | awk '{print $1}')"
if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
    echo "sha256 の形が不正です" >&2
    exit 1
fi

sed -i.bak -e "s/^  version \".*\"$/  version \"$version\"/" -e "s/^  sha256 \".*\"$/  sha256 \"$sha\"/" "$CASK"
rm -f "$CASK.bak"
echo "$version"
