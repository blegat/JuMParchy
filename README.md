# JuMParchy

JuMParchy is an opinionated [JuMP](https://jump.dev/)-flavor derivative of [omarchy](https://omarchy.org/), opinionatedly configured for my workflow.

What does it do ?

- ✓ Replace the omarchy logo by the JuMP logo
- ✓ Configure NeoVim for Julia in a way that's familiar to the Julia VS code extension
- ✓ Configure NeoVim for LaTeX
- ✓ Install Zotero

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

## How does it work ?

At install, Omarchy clones [itself](https://github.com/basecamp/omarchy) at `~/.local/share/omarchy`. Then it [copies `~/.local/share/omarchy/config`](https://github.com/basecamp/omarchy/blob/8075b8b0dcd870ae3853bee99259bb41e8759c3f/install/config/config.sh#L2-L3) into `~/.config`.
At each updates, it does [`git pull` on `~/.local/share/omarchy`](https://github.com/basecamp/omarchy/blob/8075b8b0dcd870ae3853bee99259bb41e8759c3f/bin/omarchy-update-git#L15).
Then, it has migration scripts for the files in `~/.config` that were modified, it does not re-copy its `config` folder into `~/.config` to avoid overwriting user modifications.

Our script create symlinks in `~/.config` so they shouldn't be overwritten by omarchy updates.
Running `bin/setup.sh` also adds a post-update hook to omarchy that
run `git pull` and then `bash bin/setup.sh` after each omarchy update.
