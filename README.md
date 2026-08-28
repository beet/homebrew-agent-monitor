# homebrew-agent-monitor

Homebrew tap for [agent-monitor](https://github.com/beet/agent-monitor): `agentd` (daemon), `agentmon` (TUI), and `agentmon-report` (hook reporter) for monitoring Claude Code agent sessions.

## Install

```
brew tap beet/agent-monitor
brew install agent-monitor
```

If Homebrew refuses to load the formula with "untrusted tap", trust it first:

```
brew trust beet/agent-monitor
```

## Releasing a new version

1. In the [main repo](https://github.com/beet/agent-monitor), tag and push the new version, then create a GitHub release:
   ```
   git tag -a vX.Y.Z -m "vX.Y.Z"
   git push origin vX.Y.Z
   gh release create vX.Y.Z --title "vX.Y.Z" --notes "..."
   ```
2. Download the release tarball and compute its checksum:
   ```
   curl -sL "https://github.com/beet/agent-monitor/archive/refs/tags/vX.Y.Z.tar.gz" -o /tmp/agent-monitor-vX.Y.Z.tar.gz
   shasum -a 256 /tmp/agent-monitor-vX.Y.Z.tar.gz
   ```
3. In this tap repo, update `Formula/agent-monitor.rb`'s `url` and `sha256` to match, then commit and push.
4. Update your local tap clone and verify the new version installs:
   ```
   cd "$(brew --repo beet/agent-monitor)" && git pull
   brew reinstall --build-from-source agent-monitor
   brew audit --formula agent-monitor
   ```
