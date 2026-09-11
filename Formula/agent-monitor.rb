class AgentMonitor < Formula
  desc "TUI and daemon for monitoring Claude Code agent sessions"
  homepage "https://github.com/beet/agent-monitor"
  url "https://github.com/beet/agent-monitor/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1754e1d1b6cbff258981104b360abe27103a495b9fe6237430ad4163575e6fed"
  head "https://github.com/beet/agent-monitor.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/agentd")
    system "cargo", "install", *std_cargo_args(path: "crates/agentmon")
    system "cargo", "install", *std_cargo_args(path: "crates/agentmon-report")
    (share/"agent-monitor").install "rspec-formatter/rspec_formatter.rb"
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

      Optional: to report RSpec test-run status in a Ruby project, run
      `agentmon init-rspec` in that project's root directory.
    EOS
  end

  test do
    ENV["HOME"] = testpath
    system "#{bin}/agentmon-report", "install-hooks"
    assert_path_exists testpath/".claude/settings.json"
    assert_path_exists share/"agent-monitor/rspec_formatter.rb"
  end
end
