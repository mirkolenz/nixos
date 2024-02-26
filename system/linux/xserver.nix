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
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = user.login;
      };
    };
    desktopManager = {
      gnome.enable = true;
    };
    layout = "us";
    xkbVariant = "";
    excludePackages = with pkgs; [ xterm ];
  };
  # Enable/disable default GNOME apps.
  services.gnome.core-utilities.enable = false;
  security.pam.services.gdm.enableGnomeKeyring = true;
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  # Gnome themes
  programs.dconf.enable = true;
}
