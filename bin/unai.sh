#!/usr/bin/env bash
# Reverse ai.sh: remove code-on-incus and optionally the dependencies ai.sh added.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

coi_repo="$HOME/git/System/code-on-incus"
coi_dir="$HOME/.coi"
bindings_file="$HOME/.config/hypr/bindings.conf"

coi_binding='bindd = SUPER SHIFT ALT, A, Opencode, exec, uwsm-app -- xdg-terminal-exec -- coi shell --profile opencode'
grok_binding='bindd = SUPER SHIFT ALT, A, Grok, exec, omarchy-launch-webapp "https://grok.com"'

remove_iptables_rule() {
  local description="$1"
  local chain="$2"
  shift 2

  if ! command -v iptables >/dev/null 2>&1; then
    return
  fi

  while sudo iptables -C "$chain" "$@" >/dev/null 2>&1; do
    doing "$description"
    sudo iptables -D "$chain" "$@"
  done
}

doing "Remove COI containers and images"
if command -v incus >/dev/null 2>&1; then
  if incus list >/dev/null 2>&1; then
    # COI containers and images use the coi- prefix. Do not touch unrelated
    # Incus objects unless Incus itself is removed below.
    while IFS= read -r name; do
      [ -n "$name" ] || continue
      doing "Delete Incus instance $name"
      incus delete "$name" --force
    done < <(incus list --format csv -c n 2>/dev/null | grep '^coi-' || true)

    # Delete by fingerprint. The alias column abbreviates multiple aliases as
    # "coi-default (1 more)", which is display text rather than a valid alias.
    while IFS= read -r fingerprint; do
      [ -n "$fingerprint" ] || continue
      doing "Delete COI Incus image $fingerprint"
      incus image delete "$fingerprint"
    done < <(incus image list coi- --format csv -c F 2>/dev/null | sort -u || true)
  else
    fail "Cannot access Incus; skipping COI containers and images"
  fi
fi

doing "Remove COI executable and privileged configuration"
sudo rm -f /usr/local/bin/coi /usr/local/bin/claude-on-incus
sudo rm -f /etc/sudoers.d/coi-nft

if [ -f /etc/NetworkManager/conf.d/99-coi-unmanaged.conf ]; then
  sudo rm -f /etc/NetworkManager/conf.d/99-coi-unmanaged.conf
  sudo systemctl reload NetworkManager 2>/dev/null || true
fi

remove_iptables_rule "Remove Incus DHCP firewall rule" INPUT -i incusbr0 -p udp --dport 67 -j ACCEPT
remove_iptables_rule "Remove Incus DNS UDP firewall rule" INPUT -i incusbr0 -p udp --dport 53 -j ACCEPT
remove_iptables_rule "Remove Incus DNS TCP firewall rule" INPUT -i incusbr0 -p tcp --dport 53 -j ACCEPT
remove_iptables_rule "Remove Incus inbound forwarding rule" FORWARD -i incusbr0 -j ACCEPT
remove_iptables_rule "Remove Incus outbound forwarding rule" FORWARD -o incusbr0 -j ACCEPT

if command -v nft >/dev/null 2>&1 && sudo nft list table ip coi >/dev/null 2>&1; then
  doing "Remove COI nftables table"
  sudo nft delete table ip coi
fi

if [ -e "$coi_dir" ]; then
  doing "Remove $coi_dir"
  sudo chattr -R -i "$coi_dir" 2>/dev/null || true
  rm -rf -- "$coi_dir"
fi

if [ -f "$bindings_file" ] && grep -Fxq "$coi_binding" "$bindings_file"; then
  doing "Restore Grok keybinding"
  COI_BINDING="$coi_binding" GROK_BINDING="$grok_binding" \
    perl -0pi -e 's/\Q$ENV{COI_BINDING}\E/$ENV{GROK_BINDING}/' "$bindings_file"

  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
    hypr_errors="$(hyprctl configerrors 2>/dev/null || true)"
    if [ -n "$hypr_errors" ]; then
      fail "Hyprland configuration errors:"
      printf '%s\n' "$hypr_errors" >&2
    fi
  fi
fi

if confirm "Remove Incus and ALL remaining Incus containers, images, networks, and storage?"; then
  doing "Stop and remove Incus"
  sudo systemctl disable --now incus.service incus.socket 2>/dev/null || true
  omarchy pkg drop incus
  sudo rm -rf -- /var/lib/incus
  sudo gpasswd -d "$USER" incus-admin 2>/dev/null || true
  ok "Incus removed; log out and back in to refresh group membership"
else
  ok "Incus left installed"
fi

if confirm "Remove opencode and podman (even if they existed before ai.sh)?"; then
  omarchy pkg drop opencode podman
else
  ok "opencode and podman left installed"
fi

if [ -d "$coi_repo" ] && confirm "Remove the code-on-incus source checkout at $coi_repo?"; then
  doing "Remove $coi_repo"
  rm -rf -- "$coi_repo"
else
  ok "code-on-incus source checkout left in place"
fi

ok "AI/COI uninstall complete"
