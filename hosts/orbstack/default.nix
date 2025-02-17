{ modulesPath, user, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix

  imports = [
    ./hardware.nix
    ./configuration.nix
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  custom.profile.isWorkstation = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.trusted-users = [ user.login ];

  home-manager.users.${user.login} = {
    services.vscode-server.enable = true;
  };
}
