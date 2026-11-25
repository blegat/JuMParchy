# JuMParchy

JuMParchy is an opinionated [JuMP](https://jump.dev/)-flavor derivative of [omarchy](https://omarchy.org/), opinionatedly configured for my workflow.

What does it do ?

- ✓ Replace the Omarchy screensaver logo with the JuMP logo
- ✓ Configure NeoVim for Julia in a way that's familiar to the Julia VS code extension
- ✓ Configure NeoVim for LaTeX
- ✓ Install Zotero
- ✓ Keep the laptop’s occupied workspace numbers when closing the lid with one external display

What does it not do ?

- ✗ Optimize your battery life with JuMP
- ✗ Install a bitcoin miner on your computer and donate the profits to JuMP

## Installation

First, install [omarchy](https://omarchy.org/), then clone this repo anywhere, `cd` into it and run
```sh
$ bash bin/setup.sh
```
The script is *idempotent* which means that running it again should just leave your system unchanged.
This allows making changes to the script and re-running it to update the system while making the part that weren't changed unaffected.

## How does it work?

Omarchy 4.5 ships its commands and shared defaults under `/usr/share/omarchy`. Its packages also install config files in `/etc/skel/.config`, which seed `~/.config` when a user account is created. On an existing installation, `omarchy update` upgrades the packages and runs pending migrations. A migration can update individual user configs. To refresh the whole set of shipped config files, follow [Updates](#updates).

JuMParchy’s `bin/setup.sh` calls `bin/config.sh` to symlink each file in this repo’s `config/` directory into the corresponding path under `~/.config`. For example, `~/.config/alacritty/alacritty.toml` points to the copy in your JuMParchy checkout, so edits there take effect through the link. Setup also links the JuMP screensaver logo, adds the shell profile to `~/.bashrc`, and applies the app-specific settings.

## Updates

After upgrading to Omarchy 4.5, you can refresh `~/.config` from the packaged defaults in `/etc/skel/.config` and reapply JuMParchy.
If you keep all your customizations in JuMParchy, close Chromium (the defaults include its preferences), then run the following from the JuMParchy folder as your normal user.

```sh
backup="$HOME/.jumparchy-backup.$(date +%Y%m%d-%H%M%S)"
rsync -rlpc --backup --backup-dir="$backup/config" /etc/skel/.config/ "$HOME/.config/" &&
  ./bin/setup.sh
```

`rsync` saves the entries it replaces under `$backup/config` and keeps files that exist only in `~/.config`.
Once the copy succeeds, `setup.sh` restores JuMParchy’s symlinks and settings.

## How does it work ?

At install, Omarchy clones [itself](https://github.com/basecamp/omarchy) at `~/.local/share/omarchy`. Then it [copies `~/.local/share/omarchy/config`](https://github.com/basecamp/omarchy/blob/8075b8b0dcd870ae3853bee99259bb41e8759c3f/install/config/config.sh#L2-L3) into `~/.config`.
At each updates, it does [`git pull` on `~/.local/share/omarchy`](https://github.com/basecamp/omarchy/blob/8075b8b0dcd870ae3853bee99259bb41e8759c3f/bin/omarchy-update-git#L15).
Then, it has migration scripts for the files in `~/.config` that were modified, it does not re-copy its `config` folder into `~/.config` to avoid overwriting user modifications.

Our script create symlinks in `~/.config` so they shouldn't be overwritten by omarchy updates.
Running `bin/setup.sh` also adds a post-update hook to omarchy that
run `git pull` and then `bash bin/setup.sh` after each omarchy update.

## Clamshell workspaces

With one external display, closing the lid gives the laptop’s occupied workspaces
their usual numbers on that display. JuMParchy moves conflicting external
workspaces to higher slots or to the bar’s guest section if those slots are
full. Reopening the lid returns the workspaces to their original displays and slots.

`bin/config.sh` builds the Hyprland override from the installed Omarchy module.
If an Omarchy update changes the code the patch depends on, JuMParchy reports the
mismatch and Hyprland uses Omarchy’s workspace behavior.
