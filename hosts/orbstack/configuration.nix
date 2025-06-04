# /etc/nixos/configuration.nix
{ lib, lib', ... }:
{
  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = lib.mkForce false;

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  users.groups.orbstack.gid = 67278;

  users.users.mlenz = {
    uid = 501;
    extraGroups = [
      "wheel"
      "orbstack"
    ];

    # simulate isNormalUser, but UID < 1000
    isNormalUser = lib.mkForce false;
    isSystemUser = true;
    group = lib.mkForce "users";
    createHome = true;
    home = "/home/mlenz";
    homeMode = "700";
    useDefaultShell = true;
  };

  # Extra certificates from OrbStack.
  security.pki.certificateFiles = lib'.flocken.optionalPath /opt/orbstack-guest/run/extra-certs.crt;
}
