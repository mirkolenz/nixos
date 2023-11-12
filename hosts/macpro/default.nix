{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-hidpi
    ./hardware.nix
    ./samba.nix
    ../../templates/server.nix
  ];
  networking.hostName = "macpro";
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
  systemd.services.enable-autorestart = {
    script = "${lib.getBin pkgs.pciutils}/bin/setpci -s 00:1f.0 0xa4.b=0";
    wantedBy = ["default.target"];
    after = ["default.target"];
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
