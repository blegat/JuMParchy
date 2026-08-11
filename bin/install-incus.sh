#!/usr/bin/env bash
# install-incus:summary=Install incus and

#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

omarchy-pkg-add incus

# code-on-incus need the user to be in `incus-admin`
if id -nG "$USER" | grep -qw incus-admin; then
  ok "Incus access"
else
  doing "Add $USER to incus-admin"
  sudo usermod -aG incus-admin "$USER"
  abort "Log out and back in to apply Incus access, then run ai.sh again"
fi
