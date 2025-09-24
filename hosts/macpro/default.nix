{
  pkgs,
  lib,
  lib',
  inputs,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel/cpu-only.nix"
    "${inputs.nixos-hardware}/common/gpu/amd"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./hardware.nix
    ./timemachine.nix
  ]
  ++ lib'.flocken.optionalPath "/etc/nixos/default.nix";

  custom.profile.isServer = true;
  custom.impureRebuild = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  virtualisation.libvirtd.enable = true;

  # https://wiki.nixos.org/wiki/Hardware/Apple
  # https://superuser.com/a/1051137
  systemd.services.autorestart-powerloss = {
    script = "${lib.getExe' pkgs.pciutils "setpci"} -s 00:1f.0 0xa4.b=0";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
  };

  networking.useDHCP = false;
  # must match the rule names in homeserver config
  systemd.network.networks = {
    "50-enp9s0" = {
      name = "enp9s0";
      DHCP = "yes";
      linkConfig.RequiredForOnline = true;
    };
    "50-enp10s0" = {
      name = "enp10s0";
      DHCP = "yes";
      linkConfig.RequiredForOnline = false;
    };
  };

  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
    ];
    useRoutingFeatures = "server";
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
