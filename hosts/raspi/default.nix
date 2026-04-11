# https://wiki.nixos.org/wiki/NixOS_on_ARM#Installation
{
  inputs,
  pkgs,
  lib',
  ...
}:
{
  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/raspberry-pi/4"
  ];

  # todo: nixos-hardware migrated to custom kernels without binary caches
  # workaround for https://github.com/NixOS/nixos-hardware/commit/c8f766fd11c8b0a9832b6ca1819de74fbfee3d73
  # waiting on https://github.com/NixOS/nixos-hardware/issues/325
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

  custom.features.withAlwaysOn = true;

  hardware.raspberry-pi."4" = {
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/poe-plus-hat.nix
    poe-plus-hat.enable = true;
  };

  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
    ];
    useRoutingFeatures = "server";
  };

  environment.systemPackages = with pkgs; [
    raspberrypi-eeprom
  ];
}
