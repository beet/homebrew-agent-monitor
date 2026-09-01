class AgentMonitor < Formula
  desc "TUI and daemon for monitoring Claude Code agent sessions"
  homepage "https://github.com/beet/agent-monitor"
  url "https://github.com/beet/agent-monitor/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "707b47eb2c8e1dc8817ee8644347b6be940f878e04691764830c1d1bdcc34bff"
  head "https://github.com/beet/agent-monitor.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/agentd")
    system "cargo", "install", *std_cargo_args(path: "crates/agentmon")
    system "cargo", "install", *std_cargo_args(path: "crates/agentmon-report")
  end

  def caveats
    <<~EOS
      To finish setup:
        1. Register Claude Code hooks:
             agentmon-report install-hooks
        2. Install and start the background daemon:
             agentd install

      Then run `agentmon` to view tracked agent sessions.
    EOS
  end

  test do
    ENV["HOME"] = testpath
    system "#{bin}/agentmon-report", "install-hooks"
    assert_path_exists testpath/".claude/settings.json"
  end
end
