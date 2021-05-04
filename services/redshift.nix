{ config, lib, pkgs, ... }:

{
  services = {
    redshift = {
      enable = true;
      settings = {
        redshift = {
          adjustment-method = "randr";
          gamma = 0.8;
        };
      };
      # FIXME Phase2
      latitude = "51.6";
      longitude = "0.0";
      temperature = {
        day = 5000;
        night = 3000;
      };
    };
  };
}
