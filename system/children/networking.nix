{ ... }:
{
  networking = {
    useNetworkd = true;
    # this is not compatible with networkd
    useHostResolvConf = false;
    nftables.enable = true;
    firewall.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  services.firewalld.enable = true;

  # Do not manage wifi interfaces with networkd by default
  systemd.network.networks."90-wlan" = {
    matchConfig.Type = "wlan";
    linkConfig.Unmanaged = true;
  };
}
