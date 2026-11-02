cask "agentlight" do
  version "0.2.0"
  sha256 "38a373a3f92ecfe53092f881a748d3aad613ba6d8fd934fc34415f2174ba0882"

  url "https://github.com/grisha-gu/agentlight/releases/download/v#{version}/AgentLight-#{version}.zip"
  name "AgentLight"
  desc "Traffic-light indicator for Claude Code sessions"
  homepage "https://github.com/grisha-gu/agentlight"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "AgentLight.app"
  binary "#{appdir}/AgentLight.app/Contents/MacOS/agentlight"

  # `brew upgrade` runs the old version's `uninstall`, so the LaunchAgent and hooks
  # are left alone there; only restart the daemon so it picks up the new binary.
  postflight_steps do
    run "/bin/sh",
        args:         ["-c", 'launchctl kickstart -k "gui/$(id -u)/dev.grisha-gu.agentlight.daemon"'],
        must_succeed: false
  end

  uninstall quit: "dev.grisha-gu.agentlight"

  zap launchctl: "dev.grisha-gu.agentlight.daemon",
      trash:     "~/.agentlight"

  caveats <<~EOS
    To start the daemon and hook it into Claude Code:
      agentlight install-daemon && agentlight install-hooks

    Before `brew uninstall`, remove them again:
      agentlight uninstall-hooks && agentlight uninstall-daemon
  EOS
end
