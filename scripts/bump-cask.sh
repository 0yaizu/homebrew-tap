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
zip_name="ClaudeGauge-$tag.zip"

current_version="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$CASK")"
current_sha="$(sed -n 's/^  sha256 "\(.*\)"$/\1/p' "$CASK")"

# 公開の直後は、zip がまだ添付されていないことがある。その場合は何もしない (次の起動でやり直す)。
if ! gh release view "$tag" --repo "$APP_REPO" --json assets --jq '.assets[].name' | grep -qx "$zip_name"; then
    echo "$zip_name は、まだ添付されていません" >&2
    exit 0
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
gh release download "$tag" --repo "$APP_REPO" --pattern "$zip_name" --dir "$work"

# 本体の release.yml が、このタグのコミットからビルドした zip であることを、由来の証明 (attestation) で確かめる。
# 添付された .sha256 は信用せず、検証した zip から sha256 を計算する。
gh attestation verify "$work/$zip_name" --repo "$APP_REPO" \
    --signer-workflow "$APP_REPO/.github/workflows/release.yml" \
    --source-ref "refs/tags/$tag" --deny-self-hosted-runners >&2
sha="$(shasum -a 256 "$work/$zip_name" | awk '{print $1}')"
if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
    echo "sha256 の形が不正です" >&2
    exit 1
fi

# version と sha256 の両方が同じなら、何もしない (同じタグで zip を作り直したときは、sha256 だけが変わる)。
[[ "$version" != "$current_version" || "$sha" != "$current_sha" ]] || exit 0

sed -i.bak -e "s/^  version \".*\"$/  version \"$version\"/" -e "s/^  sha256 \".*\"$/  sha256 \"$sha\"/" "$CASK"
rm -f "$CASK.bak"
# sed が行を書き換えられなかったときに、気づけるようにする。
grep -qx "  version \"$version\"" "$CASK"
grep -qx "  sha256 \"$sha\"" "$CASK"
echo "$version"
