{ config, pkgs, lib, ... }:

let
  user = "mike";
  hostname = "kodi";
in {
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; ref = "master"; rev = "8870dcaff63dfc6647fb10648b827e9d40b0a337"; }}/raspberry-pi/3"
    ./hardware-configuration.nix
  ];

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

  environment.systemPackages = with pkgs; [
    bottom
    curl
    git
    helix
    lynx
    wget
  ];

  programs.fish.enable = true;
  services.openssh.enable = true;
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = user;
    };
  };
  services.xserver = {
    enable = true;
    desktopManager.kodi.enable = true;
    desktopManager.kodi.package = pkgs.kodi.withPackages (pkgs: with pkgs; [
      pdfreader
      youtube
  	]);
    displayManager.lightdm.greeter.enable = false;
    xkb = {
      layout = "pl";
      variant = "colemak";
    };
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.tailscale.enable = true;

  console.useXkbConfig = true;
  time.timeZone = "Europe/Warsaw";
  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users."${user}" = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "audio" "disk" "networkmanager" "video" "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiZ/5BJcFcSfSfrfwT1cy52zHQP23F81AoxnB850Yol nixos@Star"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIH0uiT3vy0DVxDHI82v1EW/NxteksHexFcKdXHLcc+L nixos@Arrakis"
      ];
    };
    shell = pkgs.fish;
  };

  hardware.enableRedistributableFirmware = true;
  system.copySystemConfiguration = true;
  system.stateVersion = "24.11";
}
