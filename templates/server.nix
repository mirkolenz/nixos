{ lib, pkgs, ... }:
{
  imports = [
    ../system/common
    ../system/linux
  ];

  services.openssh.enable = true;
  custom.docker = {
    enable = true;
    userns-remap = true;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "mirkolenz/nixos";
    # flags = [ "--recreate-lock-file" ];
  };
}
