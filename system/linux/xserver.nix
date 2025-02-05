{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.services.xserver.enable {
  # Packages
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      anydesk
      google-chrome
      obsidian
      zoom-us
      zotero
    ];
  };
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    xserver = {
      xkb.layout = "us";
      excludePackages = with pkgs; [ xterm ];
    };
  };
  # there is an issue with wpa_supplicant and broadcom-wl (used in Macs)
  networking.networkmanager.wifi.backend = "iwd";
}
