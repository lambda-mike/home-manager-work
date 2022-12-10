#!/usr/bin/env bash
nix-shell --run "niv modify nixpkgs -a branch=${1}" niv.nix
