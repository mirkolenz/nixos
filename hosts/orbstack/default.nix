{
  modulesPath,
  user,
  lib',
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix
  imports = lib'.flocken.getModules ./. ++ [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  custom.nix.settings.trusted-users = [ user.login ];
}
