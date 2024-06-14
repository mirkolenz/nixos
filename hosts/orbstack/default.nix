{ modulesPath, inputs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix

  imports = [
    ./hardware.nix
    ./configuration.nix
    inputs.vscode-server.nixosModule
    "${modulesPath}/virtualisation/lxc-container.nix"
    ../../profiles/headless.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  services.vscode-server.enable = true;
}
