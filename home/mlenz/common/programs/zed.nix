{
  pkgs,
  config,
  ...
}:
{
  programs.zed-editor = {
    enable = pkgs.stdenv.isLinux && config.custom.profile.isDesktop;
  };
}
