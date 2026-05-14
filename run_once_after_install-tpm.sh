#!/bin/bash
set -euo pipefail

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Cloning TPM…"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install/update plugins declared in tmux.conf.
"$TPM_DIR/bin/install_plugins" || true
