#!/bin/bash
set -euo pipefail

# Install Claude Code via Anthropic's install script.
# Lands at ~/.local/bin/claude → ~/.local/share/claude/versions/<version>.
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code…"
  curl -fsSL https://claude.ai/install.sh | bash
fi
