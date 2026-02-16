{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.rtkit.enable = config.services.pipewire.enable;

  hardware.graphics.enable = true;

  # there is an issue with wpa_supplicant and broadcom-wl (used in Macs)
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
}
