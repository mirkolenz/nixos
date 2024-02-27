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
      gnome.gnome-tweaks
    ];
    gnome.excludePackages = with pkgs; [ gnome-tour ];
  };
  services.xserver = {
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome = {
      enable = true;
    };
    xkb.layout = "us";
    excludePackages = with pkgs; [ xterm ];
  };
  services.gnome = {
    core-utilities.enable = true;
    core-developer-tools.enable = true;
  };
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs.dconf.enable = true;
}
