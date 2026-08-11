# Sourced by other scripts; not meant to be executed directly.

set -euo pipefail

abort() {
  fail "$*"
  if [[ -t 0 ]]; then
    read -r -p "Press Enter to close..." </dev/tty || true
  fi
  exit 1
}

ok() {
  printf '\033[1;32m✓\033[0m %s\n' "$*"
}

doing() {
  printf '\033[1;34m→\033[0m %s\n' "$*"
}

fail() {
  printf '\033[1;31m✗\033[0m %s\n' "$*" >&2
}

link() {
  local desc="$1"
  local src="$2"
  local dst="$3"

  if [ ! -e "$src" ]; then
    fail "$desc: source $src does not exist"
    exit 1
  fi

  if [ -d "$dst" ]; then
    dst="$dst/$(basename "$src")"
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "$desc"
    return 0
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    fail "$desc: $dst already exists"
    exit 1
  fi

  doing "$desc"
  ln -s "$src" "$dst"
}

reset_default() {
  local desc="$1"
  local file="$2"
  local default="$3"

  if [ ! -e "$file" ] || [ -L "$file" ]; then
    return 0
  fi

  if cmp -s "$file" "$default"; then
    doing "$desc"
    rm "$file"
  else
    fail "$desc: $file differs from default $default — please review and remove manually"
    exit 1
  fi
}

ensure_line() {
  local desc="$1"
  local file="$2"
  local line="$3"

  if [ -f "$file" ] && grep -Fxq "$line" "$file"; then
    ok "$desc"
    return 0
  fi

  doing "$desc"
  echo "$line" >>"$file"
}
