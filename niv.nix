let

  sources = import ./nix/sources.nix;

  nixpkgs = sources."nixpkgs";

  pkgs = import nixpkgs {};

  niv = (import sources."niv") { inherit pkgs; };

in pkgs.mkShell {

  name = "niv-shell";

  buildInputs = [
    niv.niv
  ];

  shellHook = ''
    export NIX_PATH="niv=${sources.niv}:nixpkgs=${nixpkgs}"
  '';

}
