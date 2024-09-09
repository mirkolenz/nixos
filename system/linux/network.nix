# https://github.com/mirkolenz/nixos/commit/fb5a0a77b8157809c1b610f1931d4f94f5e6be42
{ lib, ... }:
{
  networking = {
    useNetworkd = true;
    # this is overridden by NetworkManager on workstations
    useDHCP = lib.mkDefault true;
    # this is not compatible with networkd
    useHostResolvConf = false;
  };

  systemd.network.wait-online = {
    timeout = 30;
  };

  # Do not manage wifi interfaces with networkd by default
  systemd.network.networks."90-wlan" = {
    matchConfig.Type = "wlan";
    linkConfig.Unmanaged = true;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
