let

  sources = import ./nix/sources.nix;

  nixpkgs = sources."nixpkgs";

  pkgs = import nixpkgs {};

in pkgs.mkShell {

  name = "home-manager-shell";

  buildInputs = [
    (import sources.home-manager { inherit pkgs; }).home-manager
  ];

  shellHook = ''
    export NIX_PATH="home-manager=${sources."home-manager"}:nixpkgs=${nixpkgs}"
    export HOME_MANAGER_CONFIG="./home.nix"
  '';

}
