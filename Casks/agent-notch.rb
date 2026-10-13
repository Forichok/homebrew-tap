cask "agent-notch" do
  version "0.1.0"
  sha256 "ee6605cb95a0e8bff32ba62806ab8d5c4a31691b6fd43a90fc1cb8714822f4c9"

  url "https://github.com/Forichok/Agent-Notch/releases/download/v#{version}/AgentNotch-#{version}.zip"
  name "Agent Notch"
  desc "See and approve Claude Code and Codex agents from the MacBook notch"
  homepage "https://github.com/Forichok/Agent-Notch"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Agent Notch.app"

  # The app is ad-hoc signed, not notarized: lift the download quarantine so it opens on first launch.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Agent Notch.app"],
        writable_paths: ["Agent Notch.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.forichok.agents-notch"

  zap trash: "~/Library/Preferences/com.forichok.agents-notch.plist"

  caveats <<~EOS
    If you installed the hooks, remove them before uninstalling:
      "#{appdir}/Agent Notch.app/Contents/MacOS/AgentsNotch" --uninstall-hooks
  EOS
end
