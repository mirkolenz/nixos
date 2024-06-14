# /etc/nixos/configuration.nix
{ lib, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = lib.mkForce false;

  time.timeZone = "Europe/Berlin";

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
}
