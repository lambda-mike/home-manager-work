{
  # TODO add GPG agent
  agents = [ "ssh" ];
  enable = true;
  enableZshIntegration = false;
  extraFlags = [ "--quick" ];
  # keys should contain an array of strings: [ "id_rsa" ]
  keys = import ./keys.nix;
}
