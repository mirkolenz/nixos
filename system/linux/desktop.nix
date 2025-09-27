{
  lib,
  config,
  user,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
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
  # Packages
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      anydesk
      google-chrome
      firefox
      obsidian
      zoom-us
      zotero
    ];
  };

  # there is an issue with wpa_supplicant and broadcom-wl (used in Macs)
  networking.networkmanager.wifi.backend = "iwd";

  security.rtkit.enable = config.services.pipewire.enable;

  hardware.graphics.enable = true;

  networking.networkmanager.enable = true;
  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user.login ];
    };
  };

  nix.settings.trusted-users = [ user.login ];
}
