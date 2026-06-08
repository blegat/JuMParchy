#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

CONFIG_SRC="$(cd "$SCRIPT_DIR/.." && pwd)/config"
CONFIG_DST="$HOME/.config"

while IFS= read -r -d '' src; do
  rel="${src#$CONFIG_SRC/}"
  dst="$CONFIG_DST/$rel"
  mkdir -p "$(dirname "$dst")"
  link "config/$rel" "$src" "$dst"
done < <(find "$CONFIG_SRC" -type f -print0)
