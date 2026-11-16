cask "claudegauge" do
  version "1.0.2"
  sha256 "67760d28cf24f2b99184d982d1b4b21e00bb5960bc182a3f8d2cec7fd50dc045"

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
