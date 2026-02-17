{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf (pkgs.stdenv.isLinux && config.custom.profile.isDesktop) {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
}
