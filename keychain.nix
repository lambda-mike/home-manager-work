{
  agents = [ "ssh" ];
  enable = true;
  enableZshIntegration = false;
  extraFlags = [ "--quick" "--quiet" ];
  # FIXME Phase1 keys should contain an array of strings: [ "id_rsa" ]
  keys = import ./keys.nix;
}
