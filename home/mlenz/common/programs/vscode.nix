{
  pkgs,
  config,
  ...
}:
{
  programs.vscode = {
    enable = pkgs.stdenv.isLinux && config.custom.profile.isDesktop;
    package = pkgs.vscode;
  };
}
