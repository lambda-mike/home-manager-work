{ config, pkgs, ... }:

{
  imports = [
    # <nixos-22.11/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
    <nixos-22.11/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # ./installation-cd-graphical-gnome.nix
  ];

  # module for wifi MediaTek RZ driver 7921k
  boot.kernelModules = [ "mt7921e" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="drivers", DEVPATH=="/bus/pci/drivers/mt7921e", ATTR{new_id}="14c3 0608"
  '';

  # colemak turned on by default
  console.useXkbConfig = true;
  services.xserver = {
    layout = "pl";
    xkbVariant = "colemak";
  };

  environment.systemPackages = [
      pkgs.helix
  ];

}
