{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  xserverEnabled = pkgs.stdenv.isLinux && (osConfig.services.xserver.enable or false);
in
lib.mkIf xserverEnabled {
  home.packages = with pkgs; [
    inter
    jetbrains-mono
  ];
  home.file.".face".source = ./mlenz.jpg;
  # TODO: broken
  # wayland.desktopManager.cosmic.enable = true;
}
