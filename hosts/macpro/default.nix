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
  networking.useDHCP = false;
  systemd.network = {
    netdevs = {
      "20-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
          MACAddress = "none";
        };
        bridgeConfig.STP = true;
      };
    };
    links = {
      "20-br0" = {
        matchConfig.OriginalName = "br0";
        linkConfig.MACAddressPolicy = "none";
      };
    };
    networks = {
      "20-enp9s0" = {
        name = "enp9s0";
        bridge = [ "br0" ];
        DHCP = "no";
        linkConfig.RequiredForOnline = true;
      };
      "20-enp10s0" = {
        name = "enp10s0";
        DHCP = "yes";
        linkConfig.RequiredForOnline = false;
      };
      "20-br0" = {
        name = "br0";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
        networkConfig.IPv6AcceptRA = true;
      };
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
