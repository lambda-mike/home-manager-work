# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # FIXME Phase1
    # Requiers for Intel wifi to work on laptop
    boot.kernelPackages = pkgs.linuxPackages_5_7;

    # Boot loader (UEFI)
    boot.loader.systemd-boot.configurationLimit = 30;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 1;
    boot.initrd.luks.devices = {
      root = {
        # FIXME Phase1 Set proper value
        device = "/dev/sda2";
        preLVM = true;
      };
    };

    # Networking
    networking.useDHCP = false;
    networking.interfaces.yours.useDHCP = true;
    networking.networkmanager.enable = true;
    # FIXME Phase1 Set proper name
    networking.hostName = "nixos";

    # Localization
    i18n.defaultLocale = "en_US.UTF-8";
    console.useXkbConfig = true;
    time.timeZone = "Europe/London";

    # Sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Services
    services.locate.enable = true;
    services.nixosManual.showManual = true;
    services.openssh.enable = true;
    services.thermald.enable = true;

    # X
    services.xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "colemak";

      # Touchpad support
      libinput.enable = true;

      displayManager = {
        #defaultSession = "none+i3";
        defaultSession = "none+xmonad";
        lightdm = {
          enable = true;
          autoLogin = {
            enable = true;
            user = "mike";
          };
        };
      };

      #windowManager.i3.enable = true;
      windowManager.xmonad.enable = true;

    };

    # users
    users.users.mike = {
      createHome = true;
      extraGroups = [ "wheel" "disk" "audio" "video" "networkmanager" "vboxsf" ];
      group = "users";
      home = "/home/mike";
      isNormalUser = true;
      # FIXME Phase2 Uncomment once fish is installed using home-manager
      #shell = /home/mike/.nix-profile/bin/fish;
      uid = 1000;
    };

    # Pkgs
    environment.systemPackages = with pkgs; [
      killall
      lynx
      networkmanagerapplet
      wget
      vim
    ];

}
