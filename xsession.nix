{ pkgs, config, ... }:

{
  xsession = {
    enable = true;
    windowManager.command = ''
      ${pkgs.leftwm}/bin/leftwm &
      waitPID=$!
      test -n "$waitPID" && wait "$waitPID"
    '';
  };
}
