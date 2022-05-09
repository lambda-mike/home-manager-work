{config, pkgs, ...}:
{
  imports = [
    # unstable
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    # stable
    # nix-channel --add https://nixos.org/channels/nixos-20.03 nixos-20.03
    <nixos-21.11/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixos-21.11/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # FIXED Newer kernel contains updated wifi firmware
  # nix-build '<nixos-20.03/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
  # nix-channel --add https://... nixos-21.11
  # nix-channel --update nixos-21.11
  # nix-build '<nixos-21.11/nixos>' -A config.system.build.isoImage -I nixos-config=/tmp/iso.nix -I nixos-21.11=/nix/var/nix/profiles/per-user/mike/channels/nixos-21.11/default.nix
  boot.kernelPackages = pkgs.linuxPackages_5_15;
}
