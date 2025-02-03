{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf (config.custom.profile == "workstation") {
  home.packages = with pkgs; [
    inter
    jetbrains-mono
  ];
  home.file.".face".source = ../mlenz.jpg;
  wayland.desktopManager.cosmic.enable = true;
}
