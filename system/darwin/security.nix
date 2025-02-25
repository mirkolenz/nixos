{ pkgs, ... }:
{
  security = {
    pam.services.sudo_local = {
      enable = true;
      text = ''
        auth       sufficient     ${pkgs.pam-watchid}/lib/pam_watchid.so
      '';
    };
    sudo.extraConfig = ''
      Defaults env_keep -= "HOME"
    '';
  };
}
