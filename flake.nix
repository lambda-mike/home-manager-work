{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    kolide-launcher = {
      url = "github:kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tailscale = {
      url = "github:tailscale/tailscale/v1.66.0";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.NixOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # this will be visible in configuration.nix
      specialArgs = { inherit inputs; };
      modules = [
        inputs.kolide-launcher.nixosModules.kolide-launcher
        ./configuration.nix
      ];
    };
  };
}
