{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  home.packages = with pkgs; [
    neovide
  ];
}
