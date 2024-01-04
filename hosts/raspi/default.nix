# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ./hardware.nix
      ../../profiles/server.nix
    ]
    ++ lib.flocken.optionalPath "/etc/nixos/default.nix";

  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  hardware.raspberry-pi."4" = {
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/poe-plus-hat.nix
    poe-plus-hat.enable = true;
  };

  # systemd.network.links."20-eth0" = {
  #   matchConfig.OriginalName = "end0";
  #   linkConfig.Name = "eth0";
  # };

  powerManagement.cpuFreqGovernor = "ondemand";
}
