{ ... }:
{
  imports = [
    ./uv.nix
    ./tex-fmt.nix
  ];
  home.shell.enableShellIntegration = true;
}
