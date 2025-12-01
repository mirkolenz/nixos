{ lib, config, ... }:
{
  networking = {
    useNetworkd = true;
    firewall.enable = true;
    # this is overridden by NetworkManager on workstations
    useDHCP = lib.mkDefault true;
    # this is not compatible with networkd
    useHostResolvConf = false;
  };

  services.firewalld.enable = config.networking.firewall.enable;

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
