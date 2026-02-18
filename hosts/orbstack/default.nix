{
  modulesPath,
  user,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix
  imports = [
    ./hardware.nix
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  custom.nix.settings.trusted-users = [ user.login ];

  users.users = {
    root.hashedPasswordFile = null;
    "${user.login}".hashedPasswordFile = null;
  };
}
