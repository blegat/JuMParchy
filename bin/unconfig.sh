#!/usr/bin/env bash
# Reverse of config.sh: remove the symlinks it installed under ~/.config and,
# wherever the repo file declares one with [REPLACES_COPY_OF], drop the Omarchy
# default back in its place.
#
# Run this before omarchy-reinstall-configs. It copies the defaults with
# `cp -R`, which writes *through* a symlink and would overwrite this repo's
# files with the stock versions. It also lets setup.sh relink afterwards:
# link() refuses to touch a destination that already exists, so a stale link
# from an older clone would abort it.
#
# A link pointing at this clone is removed without asking. One pointing
# anywhere else - an older clone, or something you linked by hand - is reported
# and removed only if you confirm.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

CONFIG_SRC="$(cd "$SCRIPT_DIR/.." && pwd)/config"
CONFIG_DST="$HOME/.config"

while IFS= read -r -d '' src; do
  rel="${src#"$CONFIG_SRC"/}"
  dst="$CONFIG_DST/$rel"

  default=""
  first_line=$(head -n1 "$src")
  if [[ $first_line == *"[REPLACES_COPY_OF] "* ]]; then
    default="${first_line#*\[REPLACES_COPY_OF\] }"
    default="${default/#\~/$HOME}"
  fi

  restore_default "config/$rel" "$dst" "$src" "$default"
done < <(find "$CONFIG_SRC" -type f -print0)
