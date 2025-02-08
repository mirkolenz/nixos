{
  pkgs,
  lib,
  lib',
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./hardware.nix
    ./timemachine.nix
  ] ++ lib'.flocken.optionalPath "/etc/nixos/default.nix";

  custom.profile = "server";
  custom.impure_rebuild = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # https://nixos.wiki/wiki/Hardware/Apple
  # https://superuser.com/a/1051137
  systemd.services.autorestart-powerloss = {
    script = "${lib.getExe' pkgs.pciutils "setpci"} -s 00:1f.0 0xa4.b=0";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
  };

  # systemd.network.links."20-ethernet0" = {
  #   # matchConfig.OriginalName = "enp9s0";
  #   matchConfig.PermanentMACAddress = "40:6c:8f:b8:58:95";
  #   linkConfig.Name = "ethernet0";
  # };
  # systemd.network.links."20-ethernet1" = {
  #   # matchConfig.OriginalName = "enp10s0";
  #   matchConfig.PermanentMACAddress = "40:6c:8f:b8:78:b3";
  #   linkConfig.Name = "ethernet1";
  # };
  systemd.network.networks."20-failover" = {
    matchConfig.Name = "enp10s0";
    linkConfig.RequiredForOnline = false;
    DHCP = "yes";
  };

  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
    ];
    useRoutingFeatures = "server";
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
