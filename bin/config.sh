#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

CONFIG_SRC="$(cd "$SCRIPT_DIR/.." && pwd)/config"
CONFIG_DST="$HOME/.config"

while IFS= read -r -d '' src; do
  rel="${src#$CONFIG_SRC/}"
  dst="$CONFIG_DST/$rel"
  mkdir -p "$(dirname "$dst")"

  first_line=$(head -n1 "$src")
  if [[ $first_line == *"[REPLACES_COPY_OF] "* ]]; then
    default="${first_line#*\[REPLACES_COPY_OF\] }"
    default="${default/#\~/$HOME}"
    reset_default "Clear default $rel so it can be symlinked" "$dst" "$default"
  fi

  link "config/$rel" "$src" "$dst"
done < <(find "$CONFIG_SRC" -type f -print0)

bash "$SCRIPT_DIR/clamshell-workspaces.sh"
