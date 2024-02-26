{
  pkgs,
  config,
  lib,
  user,
  ...
}:
lib.mkIf config.services.xserver.enable {
  # Packages
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages =
      (with pkgs; [
        google-chrome
        gparted
        gnome-console
      ])
      ++ (with pkgs.gnome; [
        nautilus
        gnome-system-monitor
        gnome-disk-utility
        gnome-tweaks
        gnome-shell-extensions
        dconf-editor
        yelp
      ]);
  };
  services.xserver = {
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome = {
      enable = true;
    };
    layout = "us";
    xkbVariant = "";
    excludePackages = with pkgs; [ xterm ];
  };
  services.gnome.core-utilities.enable = false;
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs.dconf.enable = true;
}
