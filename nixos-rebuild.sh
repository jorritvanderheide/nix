#!/usr/bin/env bash

set -euo pipefail

# Function to print usage
usage() {
  echo "Usage: $0 <hostname>"
  exit 1
}

# Function to autoformat Nix files
autoformat_nix_files() {
  alejandra . &>/dev/null || {
    alejandra .
    echo "Formatting failed!"
    exit 1
  }
}

# Function to rebuild NixOS
rebuild_nixos() {
  local hostname=$1
  sudo nixos-rebuild switch --flake .#$hostname &>nixos-rebuild.log || {
    cat nixos-rebuild.log | grep --color error
    exit 1
  }
}

# Function to commit changes
commit_changes() {
  local current
  current=$(nixos-rebuild list-generations | grep current)
  git commit -am "$current"
}

# Check if hostname is provided
if [ $# -ne 1 ]; then
  usage
fi

HOSTNAME=$1

# Navigate to the NixOS configuration directory
pushd /etc/nixos &>/dev/null

# Pull the latest changes from the git repository
echo "Pulling the latest changes..."
git pull

# Autoformat all Nix files
echo "Formatting Nix files..."
autoformat_nix_files

# Show the changes
git add .
git diff -U0 '*.nix'

echo "Rebuilding NixOS..."

# Rebuild NixOS
rebuild_nixos "$HOSTNAME"

# Commit all changes with the generation metadata
commit_changes

# Back to where you were
popd &>/dev/null

# Notify all OK!
echo "Rebuild successfull"