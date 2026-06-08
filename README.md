# Setup

Setup scripts that I use to configure [omarchy](https://omarchy.org/) for my workflow.
To try it, simply run
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
