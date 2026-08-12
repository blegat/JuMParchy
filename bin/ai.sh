#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
omarchy-pkg-add podman
omarchy-pkg-add opencode
"$SCRIPT_DIR/install-incus.sh"

coi_opencode_profile="$HOME/.coi/profiles/opencode/config.toml"

if command -v coi >/dev/null 2>&1; then
  ok "code-on-incus"
else
  "$SCRIPT_DIR/install-coi.sh"
fi

if [ -f "$coi_opencode_profile" ]; then
  ok "COI OpenCode profile"
else
  doing "Create COI OpenCode profile"
  mkdir -p "$(dirname "$coi_opencode_profile")"
  printf '[tool]\nname = "opencode"\npermission_mode = "bypass"\n' >"$coi_opencode_profile"
fi

bindings_file="$HOME/.config/hypr/bindings.conf"
chatgpt_binding='bindd = SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"'
opencode_binding='bindd = SUPER SHIFT, A, Opencode, exec, uwsm-app -- xdg-terminal-exec -- opencode'
legacy_opencode_binding='bindd = SUPER SHIFT ALT, A, Opencode, exec, uwsm-app -- xdg-terminal-exec -- opencode'
grok_binding='bindd = SUPER SHIFT ALT, A, Grok, exec, omarchy-launch-webapp "https://grok.com"'
coi_binding='bindd = SUPER SHIFT ALT, A, Opencode, exec, uwsm-app -- xdg-terminal-exec -- coi shell --profile opencode'

if grep -Fxq "$opencode_binding" "$bindings_file"; then
  ok "Opencode keybinding"
elif grep -Fxq "$chatgpt_binding" "$bindings_file"; then
  doing "Set Opencode keybinding"
  CHATGPT_BINDING="$chatgpt_binding" OPENCODE_BINDING="$opencode_binding" perl -0pi -e 's/\Q$ENV{CHATGPT_BINDING}\E/$ENV{OPENCODE_BINDING}/' "$bindings_file"
else
  abort "Opencode keybinding: expected ChatGPT binding not found in $bindings_file"
fi

if grep -Fxq "$coi_binding" "$bindings_file"; then
  ok "COI Opencode keybinding"
elif grep -Fxq "$legacy_opencode_binding" "$bindings_file"; then
  doing "Set COI Opencode keybinding"
  OPENCODE_BINDING="$legacy_opencode_binding" COI_BINDING="$coi_binding" perl -0pi -e 's/\Q$ENV{OPENCODE_BINDING}\E/$ENV{COI_BINDING}/' "$bindings_file"
elif grep -Fxq "$grok_binding" "$bindings_file"; then
  doing "Set COI Opencode keybinding"
  GROK_BINDING="$grok_binding" COI_BINDING="$coi_binding" perl -0pi -e 's/\Q$ENV{GROK_BINDING}\E/$ENV{COI_BINDING}/' "$bindings_file"
else
  abort "Opencode keybinding: expected Grok or Opencode binding not found in $bindings_file"
fi
