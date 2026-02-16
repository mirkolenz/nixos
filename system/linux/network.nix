{ lib, ... }:
{
  networking = {
    firewall.enable = lib.mkDefault false;
  };

  systemd.network.wait-online = {
    timeout = 30;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
