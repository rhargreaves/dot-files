#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

TARGETS=(
	".bash_aliases"
	".bash_aliases_linux"
	".config/opencode"
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
