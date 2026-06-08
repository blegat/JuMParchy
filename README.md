# Setup

Setup scripts that I use to configure [omarchy](https://omarchy.org/) for my workflow.
To try it, simply run
```sh
$ bash scripts/setup.sh
```
The script is *idempotent* which means that running it again should just leave your system unchanged.
This allows making changes to the script and re-running it to update the system while making the part that weren't changed unaffected.
