{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  time.timeZone = "Europe/Berlin";

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
