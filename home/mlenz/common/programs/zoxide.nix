{ lib, ... }:
{
  # https://github.com/ajeetdsouza/zoxide#configuration
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "z"
      "--hook"
      "prompt"
    ];
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
    _ZO_MAXAGE = "10000";
    _ZO_RESOLVE_SYMLINKS = "1";
  };
}
