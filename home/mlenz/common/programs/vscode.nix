{
  pkgs,
  config,
  ...
}:
{
  programs.vscode = {
    enable = pkgs.stdenv.isLinux && config.custom.profile == "workstation";
    package = pkgs.vscode;
  };
}
