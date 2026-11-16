cask "claudegauge" do
  version "1.0.1"
  sha256 "4fe1c2f201ea46d91161ec83d8d62ef5c831f7338534bfa928b006c7dcbeea54"

  url "https://github.com/0yaizu/claudegauge/releases/download/v#{version}/ClaudeGauge-v#{version}.zip"
  name "ClaudeGauge"
  desc "Shows Claude subscription usage in the menu bar"
  homepage "https://github.com/0yaizu/claudegauge"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "ClaudeGauge.app"

  zap trash: "~/Library/Preferences/io.github.0yaizu.ClaudeGauge.plist"

  caveats <<~EOS
    ClaudeGauge is an unofficial app and is not affiliated with Anthropic.
    It reads usage from an undocumented endpoint, which may change without notice. Use at your own risk.

    The app is not notarized. On first launch, allow it in
    System Settings > Privacy & Security ("Open Anyway").
  EOS
end
