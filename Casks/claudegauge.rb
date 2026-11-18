cask "claudegauge" do
  version "1.0.3"
  sha256 "9a9fa7499c0072a40ed84c92d2a113b27f8582b93ddcef6f3939027c9c484e6b"

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
