#! /usr/bin/env bash
nix-shell --run "home-manager expire-generations '-30 days'"
