#!/usr/bin/env bash
# Installs Miniforge and the Sage environment. Safe to run again: it skips
# what is already installed and updates the environment to match environment.yml.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONDA_DIR="$HOME/miniforge3"
CONDA="$CONDA_DIR/bin/conda"

# Install Miniforge. Batch mode (-b) leaves the shell config alone.
if [ ! -x "$CONDA" ]; then
    echo "Installing Miniforge..."
    installer="$(mktemp --suffix=.sh)"
    trap 'rm -f "$installer"' EXIT
    curl -fsSL -o "$installer" \
        "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash "$installer" -b -p "$CONDA_DIR"
fi

# Keep base from loading, so the system python3 stays the default
"$CONDA" config --set auto_activate false

# Create the environment, or bring an existing one in line with the file
if [ -d "$CONDA_DIR/envs/sage" ]; then
    echo "Updating the sage environment..."
    "$CONDA" env update -n sage -f "$REPO_DIR/environment.yml" --prune
else
    echo "Creating the sage environment..."
    "$CONDA" env create -f "$REPO_DIR/environment.yml"
fi

# Add the ctf command to new terminals
if ! grep -qF "$REPO_DIR/ctf.sh" "$HOME/.bashrc"; then
    echo "source \"$REPO_DIR/ctf.sh\"" >> "$HOME/.bashrc"
fi

"$CONDA" run -n sage sage --version
echo "Done. Open a new terminal and type: ctf"
