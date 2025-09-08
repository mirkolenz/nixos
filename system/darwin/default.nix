{
  lib',
  pkgs,
  stateVersions,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  environment.systemPackages = with pkgs; [ _1password-cli ];

  system.stateVersion = stateVersions.darwin;

  custom.podman.enable = true;
}
