#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGETS=(
  ".config/opencode"
  ".local/bin/ai-approve-cmd"
  ".pi/agent/AGENTS.md"
  ".pi/agent/extensions/quit-aliases.ts"
  ".pi/agent/settings.json"
  ".pi/agent/themes/duskfox.json"
  ".tmux.conf"
  ".zshrc"
)

[[ -L "$HOME/.local/bin/oc-approve-cmd" ]] && rm "$HOME/.local/bin/oc-approve-cmd"

for rel in "${TARGETS[@]}"; do
  src="$SCRIPT_DIR/$rel"
  dest="$HOME/$rel"
  mkdir -p "$(dirname "$dest")"
  [[ -e "$dest" && ! -L "$dest" ]] && mv "$dest" "$dest.bak"
  ln -sfn "$src" "$dest"
  printf 'linked %s -> %s\n' "$rel" "$src"
done
