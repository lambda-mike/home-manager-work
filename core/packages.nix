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
  lsof
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
  qview
  ripgrep
  rustup
  scrot
  screen
  shellcheck
  tokei
  tree
  unzip
  xfce.terminal # xfce4-terminal
  xorg.xbacklight
  xorg.xdpyinfo
  xsel
  zip
])
