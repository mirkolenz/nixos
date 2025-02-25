{ pkgs, ... }:
{
  security = {
    pam.services.sudo_local = {
      enable = true;
      # touchIdAuth = true;
      # watchIdAuth = true;
      text = ''
        auth       sufficient     pam_tid.so
        auth       sufficient     ${pkgs.pam-watchid}/lib/pam_watchid.so
      '';
    };
    sudo.extraConfig = ''
      Defaults env_keep -= "HOME"
    '';
  };
}
