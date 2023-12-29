{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-hidpi
      ./hardware.nix
      ./samba.nix
      ../server.nix
    ]
    ++ lib.flocken.optionalPath "/etc/nixos/default.nix";

  services.samba.enable = false;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

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
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
  };

  # systemd.network.links."20-eth0" = {
  #   matchConfig.OriginalName = "enp9s0";
  #   linkConfig.Name = "eth0";
  # };
  # systemd.network.links."20-eth1" = {
  #   matchConfig.OriginalName = "enp10s0";
  #   linkConfig.Name = "eth1";
  # };
  systemd.network.networks."20-failover" = {
    matchConfig.Name = "enp10s0";
    linkConfig.RequiredForOnline = false;
    DHCP = "yes";
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
