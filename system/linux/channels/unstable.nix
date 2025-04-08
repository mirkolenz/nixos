{ config, ... }:
{
  system.rebuild.enableNg = true;
  services.desktopManager.cosmic.enable = config.services.xserver.enable;
  services.displayManager.cosmic-greeter.enable = config.services.xserver.enable;
}
