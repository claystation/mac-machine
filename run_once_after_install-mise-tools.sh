#!/bin/bash
set -euo pipefail

# Installs every runtime + tool declared in ~/.config/mise/config.toml.
# Idempotent — mise skips anything already present.

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not found on PATH — brew bundle should have installed it. Skipping." >&2
  exit 0
fi

echo "Installing mise-managed tools (slow on first run)…"
mise install || \
  echo "Some mise installs failed — re-run 'mise install' manually after investigating." >&2
