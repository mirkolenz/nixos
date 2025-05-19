# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{
  inputs,
  lib',
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware}/raspberry-pi/4"
    ./hardware.nix
  ] ++ lib'.flocken.optionalPath "/etc/nixos/default.nix";

  custom.profile.isServer = true;
  custom.impureRebuild = true;

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  hardware.raspberry-pi."4" = {
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/poe-plus-hat.nix
    poe-plus-hat.enable = true;
  };

  systemd.network.links."20-ethernet0" = {
    # matchConfig.OriginalName = "end0";
    matchConfig.PermanentMACAddress = "e4:5f:01:98:a7:60";
    linkConfig.Name = "ethernet0";
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
