#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGETS=(
  ".config/opencode"
  ".local/bin/oc-approve-cmd"
  ".pi/agent/AGENTS.md"
  ".pi/agent/extensions/quit-aliases.ts"
  ".pi/agent/settings.json"
  ".tmux.conf"
  ".zshrc"
)

for rel in "${TARGETS[@]}"; do
  src="$SCRIPT_DIR/$rel"
  dest="$HOME/$rel"
  mkdir -p "$(dirname "$dest")"
  [[ -e "$dest" && ! -L "$dest" ]] && mv "$dest" "$dest.bak"
  ln -sfn "$src" "$dest"
  printf 'linked %s -> %s\n' "$rel" "$src"
done
