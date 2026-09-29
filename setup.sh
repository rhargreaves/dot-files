#!/usr/bin/env bash
set -euo pipefail

# For every file or symlink (excluding this script, README.md, AGENTS.md and .git), the
# equivalent path under $HOME is created as a symlink pointing back into the
# repo. Before replacing anything that already exists, you are asked to
# confirm. Existing regular files are backed up to <path>.bak.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF="$(basename "${BASH_SOURCE[0]}")"
SKIP=(".git" ".gitignore" ".DS_Store" "$SELF" "README.md" "AGENTS.md")

ask() {
	# ask "question" -> returns 0 for yes, 1 for no. Defaults to no.
	local reply
	read -r -p "$1 [y/N] " reply </dev/tty || return 1
	[[ "$reply" =~ ^[Yy]$ ]]
}

link_one() {
	local src="$1"
	local rel="${src#"$SCRIPT_DIR"/}"
	local dest="$HOME/$rel"
	local parent="$(dirname "$dest")"

	# Never write through a symlinked directory into another checkout.
	while [[ "$parent" != "$HOME" && "$parent" != / ]]; do
		if [[ -L "$parent" ]]; then
			printf 'skip  %s (parent is a symlink: %s)\n' "$rel" "$parent"
			return
		fi
		parent="$(dirname "$parent")"
	done

	# Already linked correctly -> nothing to do.
	if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
		printf 'ok    %s (already linked)\n' "$rel"
		return
	fi

	if [[ -e "$dest" || -L "$dest" ]]; then
		printf 'exists %s -> %s\n' "$rel" "$dest"
		if ! ask "  replace it with a symlink?"; then
			printf 'skip  %s\n' "$rel"
			return
		fi
		# Back up a real file/dir; just drop a stale/incorrect symlink.
		if [[ -L "$dest" ]]; then
			rm "$dest"
		else
			if [[ -e "$dest.bak" || -L "$dest.bak" ]]; then
				printf 'skip  %s (backup already exists: %s.bak)\n' "$rel" "$dest"
				return
			fi
			mv "$dest" "$dest.bak"
			printf 'backup %s -> %s.bak\n' "$rel" "$rel"
		fi
	else
		if ! ask "link $rel ?"; then
			printf 'skip  %s\n' "$rel"
			return
		fi
	fi

	mkdir -p "$(dirname "$dest")"
	ln -s "$src" "$dest"
	printf 'link  %s -> %s\n' "$rel" "$src"
}

should_skip() {
	local rel="$1"
	local top="${rel%%/*}"
	local name="${rel##*/}"
	[[ "$name" == ".gitignore" || "$name" == ".DS_Store" ]] && return 0
	for s in "${SKIP[@]}"; do
		[[ "$top" == "$s" ]] && return 0
	done
	return 1
}

main() {
	while IFS= read -r -d '' src; do
		local rel="${src#"$SCRIPT_DIR"/}"
		should_skip "$rel" && continue
		link_one "$src"
	done < <(find "$SCRIPT_DIR" -type d -name .git -prune -o \( -type f -o -type l \) -print0)
}

main "$@"
