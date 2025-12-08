{
  pkgs,
  lib,
  config,
  ...
}:
{
  virtualisation.podman.enable = true;

  environment.systemPackages = lib.mkIf config.virtualisation.podman.enable (
    with pkgs;
    [
      podman-compose
    ]
  );
}
