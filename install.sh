#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  mkdir -p "$(dirname "$2")"
  ln -sfn "$1" "$2"
  echo "$2 -> $1"
}

# Root dotfiles
for f in "$DOTFILES"/.[!.]*; do
  case "$(basename "$f")" in
    .git|.gitignore|.DS_Store|.config) continue ;;
    *) link "$f" "$HOME/$(basename "$f")" ;;
  esac
done

# .config directories
for d in "$DOTFILES"/.config/*; do
  [ -e "$d" ] && link "$d" "$HOME/.config/$(basename "$d")"
done
