{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  custom.nix.settings.trusted-users = [ "@wheel" ];

  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    system76-scheduler.enable = true;
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

  programs = {
    _1password.enable = true;
    nix-ld.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.rtkit.enable = config.services.pipewire.enable;

  hardware = {
    graphics.enable = true;
    facetimehd.withCalibration = true;
  };

  # there is an issue with wpa_supplicant and broadcom-wl (used in Macs)
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
}
