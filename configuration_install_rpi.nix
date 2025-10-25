# nixos-generate
# then update system.stateVersion at the bottom
# comment out most things for initial system
# OR mkswap and enable RAM
{ config, pkgs, lib, ... }:

let
  user = "mike";
  hostname = "rpi";
  tunnelUuid = "00000000-0000-0000-0000-000000000000";
  tunnelHostname = "www.example.com";
in {
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; ref = "master"; rev = "d0955d227d7c4c42ff8e0efe77d910061c5e303d"; }}/raspberry-pi/3"
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;

  system.copySystemConfiguration = true;

  fileSystems = {
    "/disk/pumba" = {
      device = "/dev/disk/by-label/pumba";
      fsType = "ext4";
      options = [ "defaults" "noatime" "nofail" ];
    };
    "/nfs/pumba" = {
      device = "/disk/pumba";
      options = [ "bind" ];
    };
  };

  # 1. fallocate -l 2G /swapfile
  # 2. mkswap -L swap /swapfile
  # 3. swapon /swapfile
  swapDevices = [
    { device = "/swapfile"; }
  ];
  hardware.bluetooth.enable = true;

  networking = {
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };
    hostName = hostname;
  };
  networking.networkmanager.enable = true;

  console.useXkbConfig = true;

  time.timeZone = "Europe/Warsaw";

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment.systemPackages = with pkgs; [
    bottom
    cloudflared
    curl
    git
    helix
    lynx
    screen
    wget
  ];

  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.cloudflared = {
    enable = true;
    tunnels = {
      ${tunnelUuid} = {
        credentialsFile = "/var/lib/cloudflared/${tunnelUuid}.json";
        certificateFile = "/var/lib/cloudflared/cert.pem";
        default = "http_status:404";
        ingress = {
          ${tunnelHostname} = {
            service = "tcp://localhost:22";
          };
        };
      };
    };
  };
  services.tailscale.enable = true;
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = user;
    };
  };
  services.xserver = {
    enable = false;
    # desktopManager.kodi.enable = true;
   #  desktopManager.kodi.package = pkgs.kodi.withPackages (pkgs: with pkgs; [
   #    pdfreader
   #    youtube
  	# ]);
   #  displayManager.lightdm.greeter.enable = false;
    xkb = {
      layout = "pl";
      variant = "colemak";
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users = {
    mutableUsers = true;
    users."${user}" = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "audio" "disk" "networkmanager" "video" "wheel" ];
      shell = pkgs.fish;
      # check ssh_keys.nix
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiZ/5BJcFcSfSfrfwT1cy52zHQP23F81AoxnB850Yol nixos@Star"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIH0uiT3vy0DVxDHI82v1EW/NxteksHexFcKdXHLcc+L nixos@Arrakis"
      ];
    };
  };

  # FIXME use correct version of the system installed
  system.stateVersion = "24.11";
}
