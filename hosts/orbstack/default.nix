{ modulesPath, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix

  imports = [
    ./hardware.nix
    ./configuration.nix
    "${modulesPath}/virtualisation/lxc-container.nix"
    ../../profiles/headless.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  home-manager.users.mlenz.services.vscode-server.enable = true;
}
