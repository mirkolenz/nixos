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
    systemPackages = with pkgs; [ google-chrome ];
    gnome.excludePackages = with pkgs; [ gnome-tour ];
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
  services.gnome = {
    core-utilities.enable = true;
    core-developer-tools.enable = true;
  };
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs.dconf.enable = true;
}
