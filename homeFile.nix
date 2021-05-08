{ config, ... }:
let emacsProfiles = import ./emacsProfiles.nix;
in {
  ".emacs-profile" = {
    text = emacsProfiles.doom;
  };
  ".emacs-profiles.el" = {
    # FIXME Phase2 install Doom to the user-emacs-directory
    text = ''
(("${emacsProfiles.doom}" . ((user-emacs-directory . "~/.doom-emacs.d")
           (env . (("DOOMDIR" . "${config.xdg.configHome}/${emacsProfiles.doom}"))))))
'';
  };
}
