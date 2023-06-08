let

  sources = import ./nix/sources.nix;

  nixpkgs = sources."nixpkgs";

  pkgs = import nixpkgs {};

in pkgs.mkShell {

  name = "home-manager-install-shell";

  buildInputs = [ ];

}
