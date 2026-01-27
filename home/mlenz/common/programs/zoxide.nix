{ lib, ... }:
{
  programs.zoxide = {
    enable = true;
  };
  home.sessionVariables = {
    _ZO_ECHO = "1";
    _ZO_EXCLUDE_DIRS = lib.concatStringsSep ":" [
      "$HOME"
      "$HOME/.*"
      "$HOME/Downloads/**"
      "$HOME/Library/**"
      "/nix/**"
      "/tmp/**"
    ];
  };
}
