class AgentMonitor < Formula
  desc "TUI and daemon for monitoring Claude Code agent sessions"
  homepage "https://github.com/beet/agent-monitor"
  url "https://github.com/beet/agent-monitor/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "fcf18de7e12e015db8080af78c75b07f110313342bffa7a0f9d2fe1014c22409"
  head "https://github.com/beet/agent-monitor.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/agentd")
    system "cargo", "install", *std_cargo_args(path: "crates/agentmon")
    system "cargo", "install", *std_cargo_args(path: "crates/agentmon-report")
  end

  service do
    run [opt_bin/"agentd"]
    keep_alive true
    run_type :immediate
    restart_delay 5
    log_dir = Pathname.new(Dir.home)/"Library/Logs/agentmon"
    log_path log_dir/"agentd.out.log"
    error_log_path log_dir/"agentd.err.log"
  end

  def caveats
    <<~EOS
      To finish setup:
        1. Register Claude Code hooks:
             agentmon-report install-hooks
        2. Start the background daemon:
             brew services start agent-monitor

      Then run `agentmon` to view tracked agent sessions.
    EOS
  end

  test do
    ENV["HOME"] = testpath
    system "#{bin}/agentmon-report", "install-hooks"
    assert_path_exists testpath/".claude/settings.json"
  end
end
