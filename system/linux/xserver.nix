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
      zotero_7
    ];
  };
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.xserver = {
    xkb.layout = "us";
  };
  # there is an issue with wpa_supplicant and broadcom-wl (used in Macs)
  networking.networkmanager.wifi.backend = "iwd";
}
