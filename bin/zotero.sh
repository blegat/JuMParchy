#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

desc="Install Zotero via flatpak"
if flatpak list --app --columns=application 2>/dev/null | grep -qx org.zotero.Zotero; then
  ok "$desc"
else
  doing "$desc"
  omarchy-pkg-add flatpak
  flatpak install flathub org.zotero.Zotero
fi

# Flatpak overrides are idempotent and also apply to existing installations.
flatpak override --user --talk-name=org.freedesktop.secrets org.zotero.Zotero
ok "Allow Zotero to access the keyring"

link "Add Zotero desktop entry" \
  /var/lib/flatpak/exports/share/applications/org.zotero.Zotero.desktop \
  "$HOME/.local/share/applications"
