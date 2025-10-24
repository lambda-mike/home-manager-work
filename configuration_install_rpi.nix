# nixos-generate
# then update system.stateVersion at the bottom
# comment out most things for initial system
# OR mkswap and enable RAM
{ config, pkgs, lib, ... }:

let
  user = "mike";
  hostname = "rpi";
in {
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; ref = "master"; rev = "d0955d227d7c4c42ff8e0efe77d910061c5e303d"; }}/raspberry-pi/3"
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
  services.openssh.enable = true;
  services.cloudflared.enable = true;
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
      shell = pkgs.fish;
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.copySystemConfiguration = true;
  # FIXME use correct version of the system installed
  system.stateVersion = "24.11";
}
