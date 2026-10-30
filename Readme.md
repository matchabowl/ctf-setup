# CTF Setup

Reproduces my CTF setup on a new machine. At the moment, it installs SageMath, pwntools and PyCryptodome in a conda environment and adds a `ctf` command to load that environment.

Conda only loads in a terminal where `ctf` is run, so the system `python3` stays the default everywhere else.

## Requirements

- bash
- git
- curl

## Installation

```bash
git clone git@github.com:matchabowl/ctf-setup.git ~/ctf/setup
~/ctf/setup/install.sh
```

Then open a new terminal.

`install.sh` does the following:

1. Installs Miniforge to `~/miniforge3` if it is missing, without running `conda init`.
2. Sets conda's `auto_activate` option to `false`, so the `base` environment doesn't load.
3. Creates the `sage` environment from `environment.yml`, or updates it if it already exists.
4. Adds a line to `~/.bashrc` that loads `ctf.sh`, which defines the `ctf` command.
5. Runs `sage --version` to check that Sage starts.

The script is safe to run again.

## Usage

```bash
ctf                # load the sage environment
sage solve.sage    # run a script
sage               # start the Sage REPL
conda deactivate   # leave the environment
```

## Adding a package

1. Add the package to `environment.yml`.
2. Run `~/ctf/setup/install.sh`.
3. Commit and push the change.
4. On other machines, run `git pull` and then `~/ctf/setup/install.sh`.

Don't use `conda install` for packages you want to keep: `install.sh` updates with `--prune`, which removes anything not listed in `environment.yml`.

## Uninstalling

```bash
rm -rf ~/miniforge3 ~/.conda ~/.condarc
```

Then remove the line that loads `ctf.sh` from `~/.bashrc`.
