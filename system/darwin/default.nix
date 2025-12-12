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
    less
  ];

  environment.variables = {
    EDITOR = "zed";
    VISUAL = "zed";
  };

  system.stateVersion = stateVersions.darwin;
}
