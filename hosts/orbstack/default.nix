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

  nix.settings.trusted-users = [ user.login ];

  home-manager.users.${user.login} = {
    programs.claude-code.enable = true;
    programs.codex.enable = true;
  };
}
