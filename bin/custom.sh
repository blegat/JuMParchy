#!/usr/bin/env bash
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/lib.sh"

cd "$SCRIPT_DIR"
doing "Pulling latest from $SCRIPT_DIR"
git pull
./setup.sh
