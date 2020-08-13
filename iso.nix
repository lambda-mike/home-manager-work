{config, pkgs, ...}:
{
  imports = [
    # unstable
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    # stable
    # nix-channel --add https://nixos.org/channels/nixos-20.03 nixos-20.03
    <nixos-20.03/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixos-20.03/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # FIXED Newer kernel contains updated wifi firmware
  # nix-build '<nixos-20.03/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
  boot.kernelPackages = pkgs.linuxPackages_5_7;
}
