{ pkgs, ... }:
(with pkgs; [
  appimage-run
  brave
  cmus
  dasel
  docker
  du-dust
  duf
  fd
  file
  font-awesome
  gimp
  git-crypt
  gnome.simple-scan
  i3lock
  libreoffice
  lsof
  neofetch
  (nerdfonts.override { fonts = [
    "Agave" "CascadiaCode" "Cousine" "FiraMono" "Hack" "Hermit" "Iosevka" "JetBrainsMono"
    "Monofur" "Mononoki" "RobotoMono" "SourceCodePro" "Terminus" "UbuntuMono"
  ]; })
  ncompress
  nil
  nixfmt
  nnn
  nodePackages.typescript-language-server
  pciutils
  pinentry
  procs
  python38
  qrencode
  qview
  ripgrep
  rnix-lsp
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
