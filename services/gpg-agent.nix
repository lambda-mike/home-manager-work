{ config, lib, pkgs, ... }:

{
  services = {
    # gpgconf --reload gpg-agent should make pinentry available
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };
}
