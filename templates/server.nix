{
  lib,
  pkgs,
  ...
}: {
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
    flake = "github:mirkolenz/nixos";
    flags = ["--impure" "--no-write-lock-file"];
    dates = "04:00";
    allowReboot = true;
    rebootWindow = {
      lower = "03:30";
      upper = "05:00";
    };
  };
}
