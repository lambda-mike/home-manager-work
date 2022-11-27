let

  sources = import ./nix/sources.nix;

  nixpkgs = sources."nixpkgs";

  pkgs = import nixpkgs {};

in pkgs.mkShell rec {

  name = "niv-shell";

  buildInputs = with pkgs; [
    pkgs.niv
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}"
  '';

}
