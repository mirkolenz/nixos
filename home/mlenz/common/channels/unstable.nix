{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./uv.nix
    ./tex-fmt.nix
    ./nix-init.nix
  ];
  home.shell.enableShellIntegration = true;
  home.shellAliases.py = "${lib.getExe' config.programs.uv.package "uv"} run";
  programs.bat.extraPackages = [ pkgs.bat-extras.core ];
  programs.gradle.enable = true;
  programs.ruff = {
    enable = true;
    settings = { };
  };
  programs.jq.enable = true;
  programs.jqp.enable = true;
}
