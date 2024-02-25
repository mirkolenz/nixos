{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  xserverEnabled = pkgs.stdenv.isLinux && (osConfig.services.xserver.enable or false);
  gnomeExtensions = with pkgs.gnomeExtensions; [
    dash-to-dock
    user-themes
    blur-my-shell
  ];
in
lib.mkIf xserverEnabled {
  home.packages = gnomeExtensions;
  gtk = {
    enable = true;
    iconTheme = {
      # package = pkgs.whitesur-icon-theme;
      # name = "WhiteSur";
      name = "Adwaita";
    };
    theme = {
      # package = pkgs.whitesur-gtk-theme;
      # name = "WhiteSur-Dark";
      name = "Adwaita";
    };
  };
  # dconf watch /
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (ext: ext.extensionUuid) gnomeExtensions;
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "code.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Settings.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
  };
}
