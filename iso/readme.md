# ISO

From nixpkgs:

```
git clone https://github.com/NixOS/nixpkgs.git
cd nixpkgs/nixos
git switch nixos-unstable
export NIXPKGS_ALLOW_UNFREE=1
nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/installation-cd-minimal.nix default.nix
nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/my-iso.nix default.nix
```

To check the content:

```
mount -o loop -t iso9660 ./result/iso/cd.iso /mnt/iso
```

From channels:

```
nix-build '<nixos-22.11/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
```
