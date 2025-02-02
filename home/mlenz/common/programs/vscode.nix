{
  pkgs,
  lib,
  osConfig,
  ...
}:
lib.mkIf (osConfig.services.xserver.enable or false) {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
}
