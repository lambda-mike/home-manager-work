# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # Boot loader (UEFI)
    boot.consoleLogLevel = 3;
    boot.kernelParams = [
      "quiet" "vga=current"
      "rd.systemd.show_status=auto" "rd.udev.log_level=3"
    ];
    boot.loader.systemd-boot.configurationLimit = 7;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 1;

    # Networking
    networking.useDHCP = false;
    networking.interfaces.wlp2s0.useDHCP = true;
    networking.networkmanager.enable = true;
    networking.hostName = "kitkowo";

    # Nix
    nix = {
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };
    };

    # Localization
    i18n.defaultLocale = "pl_PL.UTF-8";
    console.useXkbConfig = true;
    time.timeZone = "Europe/London";

    # Sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Services
    services.locate.enable = true;
    services.openssh = {
      enable = true;
      forwardX11 = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
      startWhenNeeded = true;
    };
    services.thermald.enable = true;

    # X
    services.pantheon.apps.enable = true;
    services.pantheon.contractor.enable = true;
    services.xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
      layout = "pl";

      # Touchpad support
      libinput.enable = true;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "sabi";
        };
      };
    };

    system.autoUpgrade = {
      allowReboot = false;
      dates = "monthly";
      enable = true; 
    };

    # users
    users.users.sabi = {
      createHome = true;
      extraGroups =
        [ "audio" "disk" "networkmanager" "vboxsf" "video" "wheel" ];
      group = "users";
      home = "/home/sabi";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTP5Tlnc2kzPlJ5MQk9zHo4VIZhrYugTDJgy3OOPSD4 Toshiba Kitkowo''
      ];
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
