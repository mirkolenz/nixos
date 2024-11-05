{ pkgs, lib, ... }:
{
  environment.etc."pam.d/sudo_local" = {
    enable = true;
    text = ''
      auth       optional       ${lib.getLib pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth       sufficient     ${lib.getLib pkgs.pam-watchid}/lib/pam/pam_watchid.so
      auth       sufficient     pam_tid.so
    '';
  };
}
