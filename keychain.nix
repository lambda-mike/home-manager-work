{
  # TODO add GPG agent
  agents = [ "ssh" ];
  enable = true;
  enableZshIntegration = false;
  # keys should contain array of strings: [ "id_rsa" ]
  keys = import ./keys.nix;
}
