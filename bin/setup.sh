#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_SRC="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Register custom.sh as omarchy post-update hook" \
  "$SCRIPT_DIR/custom.sh" "$HOME/.config/omarchy/hooks/post-update.d"

reset_default "Clear default omarchy screensaver branding" \
  "$HOME/.config/omarchy/branding/screensaver.txt" \
  "$HOME/.local/share/omarchy/logo.txt"

link "Use JuMP logo as screensaver" \
  "$ROOT_SRC/logo/JuMP_logo.txt" "$HOME/.config/omarchy/branding/screensaver.txt"

if cmp -s "$ROOT_SRC/logo/JuMP_logo.png" /usr/share/plymouth/themes/omarchy/logo.png; then
  ok "JuMP logo already applied to Plymouth/SDDM boot"
else
  doing "Apply JuMP logo to Plymouth/SDDM boot (sudo, rebuilds initramfs)"
  colors="$HOME/.config/omarchy/current/theme/colors.toml"
  bg=$(awk -F'"' '/^background/{print $2}' "$colors")
  fg=$(awk -F'"' '/^foreground/{print $2}' "$colors")
  omarchy-plymouth-set "$bg" "$fg" "$ROOT_SRC/logo/JuMP_logo.png"
fi

ensure_line "Source profile.sh from ~/.bashrc" \
  "$HOME/.bashrc" "source $ROOT_SRC/profile.sh"

"$SCRIPT_DIR/julia.sh"
"$SCRIPT_DIR/latex.sh"
"$SCRIPT_DIR/zotero.sh"
"$SCRIPT_DIR/ai.sh"
"$SCRIPT_DIR/config.sh"
