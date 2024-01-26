# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; ref = "master"; rev = "f84eaffc35d1a655e84749228cde19922fcf55f1"; }}/lenovo/thinkpad/p1/3th-gen"

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
    boot.supportedFilesystems = [ "ntfs" ];

    # FIXME Phase1 Set proper mount point options
    # Filesystem
    fileSystems = {
      "/".options = [ "compress=zstd:1" ];
      "/nix".options = [ "compress=zstd:1" ];
      "/home".options = [ "compress=zstd:1" ];
      "/home/data".options = [ "compress=zstd:1" ];
      "/snapshots".options = [ "compress=zstd:1" ];
      "/swap".options = [ "noatime" ];
    };
    swapDevices = [ { device = "/swap/swapfile"; } ];
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };

    # Networking
    networking.useDHCP = false;
    networking.interfaces.yours.useDHCP = true;
    networking.interfaces.yours.wakeOnLan.enable = true;
    networking.networkmanager.enable = true;
    # FIXME Phase1 Set proper name
    networking.hostName = "nixos";

    # Nix
    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };
      settings.auto-optimise-store = true;
    };

    # Localization
    i18n.defaultLocale = "en_US.UTF-8";
    console.useXkbConfig = true;
    time.timeZone = "Europe/London";

    # Sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Gaming
    hardware.pulseaudio.support32Bit = true;
    # hardware.opengl.driSupport32Bit = true;
    nixpkgs.config.allowUnfree = true;

    # Dygma Raise
    # network driver for minis
    # Dygma Defy
     services.udev.extraRules =''
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", GROUP="users", MODE="0666"
SUBSYSTEM=="drivers", DEVPATH=="/bus/pci/drivers/mt7921e", ATTR{new_id}="14c3 0608"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", ATTRS{idProduct}=="0012", GROUP="users", MODE="0666"
    '';

    # Services
    services.greenclip.enable = true;
    services.locate.enable = true;
    services.openssh = {
      enable = true;
      extraConfig = ''
ClientAliveInterval 100
'';
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      startWhenNeeded = true;
    };
    services.vnstat.enable = true;
    services.thermald.enable = true;
    # udisksctl
    services.udisks2.enable = true;
    # Printing
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.brlaser pkgs.brgenml1lpr ];

    services.tailscale.enable = true;

    # Scanner
    hardware.sane.enable = true;
    hardware.sane.brscan4.enable = true;
    hardware.bluetooth.enable = true;

    # X
    services.xserver = {
      enable = true;
      layout = "pl";
      xkbVariant = "colemak";

      # Touchpad support
      libinput.enable = true;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "mike";
        };
        defaultSession = "none+xmonad";
        lightdm.enable = true;
      };

      windowManager.xmonad.enable = true;
    };

    system.autoUpgrade = {
      allowReboot = false;
      dates = "weekly";
      enable = true;
    };

    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        # This is needed because Docker cannot resolve localhost DNS lookup
        extraOptions = "--dns 9.9.9.9";
      };
      virtualbox = {
        guest.enable = true;
        guest.x11 = true;
        host.enable = true;
      };
    };

    # users
    users.users.mike = {
      createHome = true;
      # uucp is needed by Bazecor do flash Dygma keyboards
      extraGroups =
        [ "audio" "disk" "docker" "networkmanager" "uucp" "vboxsf" "vboxusers" "video" "wheel" ];
      group = "users";
      home = "/home/mike";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIH0uiT3vy0DVxDHI82v1EW/NxteksHexFcKdXHLcc+L nixos@Arrakis''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiZ/5BJcFcSfSfrfwT1cy52zHQP23F81AoxnB850Yol nixos@Star''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKNfaNgJUXd51qUbNmi6dXYON4rSGIDt4aLhDhIPlh7 osmc@osmc''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWAyfg5RYzj8s3EV06QN1TPDH597nn63wmh1Q7tYthM xps''
      ];
      # FIXME Phase2 Uncomment once fish is installed using home-manager
      #shell = /home/mike/.nix-profile/bin/fish;
      uid = 1000;
    };

    # Pkgs
    environment.systemPackages = with pkgs; [
      android-studio
      appimage-run
      killall
      lynx
      networkmanagerapplet
      steam-run
      wget
      vim
    ];

    # Android
    programs.adb.enable = true;
    programs.command-not-found.enable = true;
    # Gaming
    programs.steam.enable = true;
    programs.mosh.enable = true;

    services.openvpn.servers = {
      hobby = {
        autoStart = false;
        # Remove cipher once the server version is upgraded
        config = ''
          cipher BF-CBC
          config /root/config.ovpn
        '';
      };
    };

    # NVidia
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
    	# accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        # Bus ID of the Intel GPU.
        intelBusId = lib.mkDefault "PCI:0:2:0";
        # Bus ID of the NVIDIA GPU.
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        offload = {
    			enable = true;
    			enableOffloadCmd = true;
    		};
      };
    };


}
