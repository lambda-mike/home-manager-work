{ pkgs, ... }:
(with pkgs; [
  brave
  docker
  du-dust
  exa
  fd
  file
  font-awesome
  gimp
  git-crypt
  haskellPackages.greenclip
  htop
  i3lock
  libreoffice
  neofetch
  (nerdfonts.override { fonts = [
    "Agave" "CascadiaCode" "Cousine" "Hack" "Hermit" "JetBrainsMono"
    "Mononoki" "SourceCodePro" "Terminus" "UbuntuMono"
  ]; })
  ncompress
  nixfmt
  nnn
  nodePackages.typescript-language-server
  pinentry
  procs
  python38
  qrencode
  ripgrep
  rustup
  scrot
  screen
  shellcheck
  tokei
  tree
  unzip
  xorg.xbacklight
  xorg.xdpyinfo
  xsel
])
