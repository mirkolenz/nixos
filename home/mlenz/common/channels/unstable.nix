{ lib, config, ... }:
{
  imports = [
    ./uv.nix
    ./tex-fmt.nix
  ];
  home.shell.enableShellIntegration = true;
  home.shellAliases.py = "${lib.getExe' config.programs.uv.package "uv"} run";
}
