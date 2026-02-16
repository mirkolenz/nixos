{ lib, ... }:
{
  networking = {
    # this is overridden by NetworkManager on workstations
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  systemd.network.wait-online = {
    timeout = 30;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
