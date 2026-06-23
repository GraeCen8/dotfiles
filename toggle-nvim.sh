#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$ROOT/nvim/.config/nvim"
MAIN_SRC="$ROOT/nvim-main/.config/nvim"
BASED_SRC="$ROOT/nvim-based"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
STATE_FILE="$STATE_DIR/nvim-active"

mkdir -p "$STATE_DIR"
mkdir -p "$(dirname "$TARGET")"

copy_tree() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"
  rsync -a --delete "$src"/ "$dst"/
}

infer_active() {
  if diff -qr "$TARGET" "$MAIN_SRC" >/dev/null 2>&1; then
    printf 'main'
  elif diff -qr "$TARGET" "$BASED_SRC" >/dev/null 2>&1; then
    printf 'based'
  else
    printf 'main'
  fi
}

desired="${1:-toggle}"
case "$desired" in
  toggle)
    active="$(if [[ -f "$STATE_FILE" ]]; then cat "$STATE_FILE"; else infer_active; fi)"
    if [[ "$active" == "main" ]]; then
      desired="based"
    else
      desired="main"
    fi
    ;;
  main|based)
    active="$(if [[ -f "$STATE_FILE" ]]; then cat "$STATE_FILE"; else infer_active; fi)"
    ;;
  *)
    echo "usage: $(basename "$0") [toggle|main|based]" >&2
    exit 1
    ;;
esac

if [[ "$active" == "main" ]]; then
  active_src="$MAIN_SRC"
else
  active_src="$BASED_SRC"
fi

if [[ "$desired" == "main" ]]; then
  desired_src="$MAIN_SRC"
else
  desired_src="$BASED_SRC"
fi

if ! diff -qr "$TARGET" "$active_src" >/dev/null 2>&1; then
  copy_tree "$TARGET" "$active_src"
fi

if ! diff -qr "$TARGET" "$desired_src" >/dev/null 2>&1; then
  copy_tree "$desired_src" "$TARGET"
fi

printf '%s\n' "$desired" > "$STATE_FILE"
echo "nvim switched to: $desired"
