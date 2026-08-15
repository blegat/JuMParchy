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

# Ask before doing something that cannot be undone. Reads the terminal rather
# than stdin, so it still works inside a loop being fed by a pipe. When there is
# no terminal to ask on the answer is no, so unattended runs never delete.
confirm() {
  local prompt="$1"
  local reply

  if [ ! -r /dev/tty ]; then
    fail "$prompt — no terminal to ask on, assuming no"
    return 1
  fi

  printf '\033[1;33m?\033[0m %s [y/N] ' "$prompt" >/dev/tty
  read -r reply </dev/tty || reply=""
  [[ ${reply,,} == y || ${reply,,} == yes ]]
}

# Reverse of link() + reset_default(): drop a symlink this repo installed and,
# when the repo file declares a [REPLACES_COPY_OF] default, put that default
# back so the location looks untouched again. Anything that is not a symlink is
# left alone - it was never ours to remove. A symlink pointing somewhere other
# than $expected was installed by something else (an older clone, or by hand),
# so removing it needs confirmation.
restore_default() {
  local desc="$1"
  local file="$2"
  local expected="$3"
  local default="${4:-}"
  local target

  if [ ! -L "$file" ]; then
    [ -e "$file" ] && ok "$desc: not a symlink, left alone"
    return 0
  fi

  target="$(readlink "$file")"

  if [ "$target" != "$expected" ]; then
    fail "$desc: points at $target"
    printf '    expected %s\n' "$expected"
    if ! confirm "Remove $file anyway?"; then
      ok "$desc: left in place"
      return 0
    fi
  fi

  doing "$desc: was -> $target"
  rm "$file"

  [ -n "$default" ] || return 0

  if [ ! -e "$default" ]; then
    fail "$desc: default $default not found, leaving $file absent"
    return 0
  fi

  mkdir -p "$(dirname "$file")"
  cp "$default" "$file"
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
