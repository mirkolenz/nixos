{
  modulesPath,
  user,
  lib,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix
  imports = [
    ./hardware.nix
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  nix.settings.trusted-users = [ user.login ];

  # todo: https://nixpkgs-tracker.ocfox.me/?pr=460219
  documentation.enable = lib.mkForce true;
  documentation.nixos.enable = lib.mkForce true;

  home-manager.users.${user.login} = {
    programs.claude-code.enable = true;
    programs.codex.enable = true;
  };
}
