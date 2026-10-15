cask "agent-notch" do
  version "0.4.1"
  sha256 "8d0d6d865a40c25aa3d42228d44d1cf02470f798aab9d7c32e8bc176bd50db38"

  url "https://github.com/Forichok/Agent-Notch/releases/download/v#{version}/AgentNotch-#{version}.zip"
  name "Agent Notch"
  desc "See and approve Claude Code and Codex agents from the MacBook notch"
  homepage "https://github.com/Forichok/Agent-Notch"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

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

  # zap runs after the app is removed: the hooks come out through the helper copy, before it is trashed.
  zap script: {
        executable: "/bin/sh",
        args:       [
          "-c",
          'h="$HOME/Library/Application Support/AgentsNotch/notch-hook"; [ -x "$h" ] && "$h" --uninstall-hooks; true',
        ],
      },
      trash:  [
        "~/Library/Application Support/AgentsNotch",
        "~/Library/Preferences/com.forichok.agents-notch.plist",
      ]

  caveats <<~EOS
    A plain uninstall keeps the Claude Code and Codex hooks. To remove them too:
      brew uninstall --zap agent-notch
  EOS
end
