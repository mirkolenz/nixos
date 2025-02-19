{ lib', config, ... }:
{
  imports = lib'.flocken.getModules ./.;

  time.timeZone = "Europe/Berlin";
  services.lorri.enable = config.custom.profile.isWorkstation;

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
