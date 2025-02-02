{
  lib,
  pkgs,
  osConfig,
  ...
}:
lib.mkIf (osConfig.services.xserver.enable or false) {
  home.packages = with pkgs; [
    inter
    jetbrains-mono
  ];
  home.file.".face".source = ../mlenz.jpg;
  wayland.desktopManager.cosmic.enable = true;
}
