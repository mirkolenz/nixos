{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf (pkgs.stdenv.isLinux && config.custom.profile.isDesktop) {
  programs.zed-editor = {
    enable = true;
  };
}
