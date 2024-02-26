{
  pkgs,
  lib,
  osConfig,
  ...
}:
lib.mkIf (pkgs.stdenv.isLinux && (osConfig.services.xserver.enable or false)) {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
}
