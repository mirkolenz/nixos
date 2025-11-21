{ inputs, user, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  # resolv.conf is managed by config.wsl.wslConf.network.generateResolvConf
  services.resolved.enable = false;

  # https://nix-community.github.io/NixOS-WSL/options.html
  wsl = {
    enable = true;
    defaultUser = user.login;
  };
}
