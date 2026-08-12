#!/usr/bin/env bash
# install-coi:summary=Install code-on-incus

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

coi_repo="$HOME/git/System/code-on-incus"

if [ ! -f "$coi_repo/install.sh" ]; then
  abort "code-on-incus installer not found at $coi_repo/install.sh"
fi

doing "Install code-on-incus"
bash "$coi_repo/install.sh"

# See https://github.com/mensfeld/code-on-incus/issues/83#issuecomment-4065301139
ensure_iptables_rule() {
  local description="$1"
  local chain="$2"
  shift 2

  if sudo iptables -C "$chain" "$@"; then
    ok "$description"
  else
    doing "$description"
    sudo iptables -I "$chain" "$@"
  fi
}

ensure_iptables_rule "Allow Incus DHCP" INPUT -i incusbr0 -p udp --dport 67 -j ACCEPT
ensure_iptables_rule "Allow Incus DNS (UDP)" INPUT -i incusbr0 -p udp --dport 53 -j ACCEPT
ensure_iptables_rule "Allow Incus DNS (TCP)" INPUT -i incusbr0 -p tcp --dport 53 -j ACCEPT
ensure_iptables_rule "Allow Incus bridge inbound forwarding" FORWARD -i incusbr0 -j ACCEPT
ensure_iptables_rule "Allow Incus bridge outbound forwarding" FORWARD -o incusbr0 -j ACCEPT

doing "Build COI image"
coi build

