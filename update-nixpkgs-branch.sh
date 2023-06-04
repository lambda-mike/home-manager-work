#!/usr/bin/env bash
# Example how to run:
# ./update-nixpkgs-branch.sh "nixos-23.05
if [ -z "${1}" ];
then
  echo 'Run with the correct branch name: ./update-nixpkgs-branch.sh "nixos-23.05"' && exit 1
else
  nix-shell --run "niv modify nixpkgs -a branch=${1}" niv.nix
fi
