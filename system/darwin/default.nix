{
  lib',
  pkgs,
  stateVersions,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  environment.systemPackages = with pkgs; [
    _1password-cli
    libvirt
    virt-viewer
    virt-manager
  ];

  system.stateVersion = stateVersions.darwin;

  virtualisation.podman.enable = true;
}
