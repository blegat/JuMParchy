#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

desc="Install Zotero via flatpak"
if flatpak list --app --columns=application 2>/dev/null | grep -qx org.zotero.Zotero; then
  ok "$desc (already done)"
else
  doing "$desc"
  omarchy-pkg-add flatpak
  flatpak install flathub org.zotero.Zotero
fi

link "Add Zotero desktop entry" \
  /var/lib/flatpak/exports/share/applications/org.zotero.Zotero.desktop \
  "$HOME/.local/share/applications"
