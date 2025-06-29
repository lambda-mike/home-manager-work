{ pkgs, ... }:

let
  sources = import ../nix/sources.nix;
  nixpkgsUnstable = sources."nixpkgs-unstable";
  pkgsUnstable = import nixpkgsUnstable {};
in (with pkgs; [
  appimage-run
  pkgsUnstable.brave
  cmus
  cryfs
  dasel
  docker
  du-dust
  duf
  fd
  file
  font-awesome
  gimp
  git-crypt
  simple-scan
  i3lock
  julia
  leftwm
  libreoffice
  lsof
  neofetch
  nerd-fonts.agave
  nerd-fonts.caskaydia-cove
  nerd-fonts.cousine
  nerd-fonts.fira-mono
  nerd-fonts.hack
  nerd-fonts.hurmit
  nerd-fonts.iosevka
  nerd-fonts.jetbrains-mono
  nerd-fonts.monofur
  nerd-fonts.mononoki
  nerd-fonts.roboto-mono
  nerd-fonts.sauce-code-pro
  nerd-fonts.terminess-ttf
  nerd-fonts.ubuntu-mono
  ncompress
  nil
  nixfmt-classic
  nnn
  pkgsUnstable.nodePackages.eslint
  pkgsUnstable.nodePackages.typescript-language-server
  pciutils
  pinentry
  procs
  python3
  qrencode
  qview
  ripgrep
  rustup
  scrot
  screen
  shellcheck
  tokei
  tree
  unzip
  xfce.xfce4-terminal
  xorg.xbacklight
  xorg.xdpyinfo
  xsel
  zip
])
