{ lib, pkgs, osConfig, extras, ... }:
lib.mkIf (pkgs.stdenv.isLinux && osConfig.services.xserver.enable) {
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    foot = {
      enable = true;
    };
  };
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
  # /org/gnome/desktop/interface/gtk-theme
  #   'Adwaita'
  # /org/gnome/shell/extensions/user-theme/name
  #   ''
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        dash-to-dock.extensionUuid
        user-themes.extensionUuid
        blur-my-shell.extensionUuid
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "code.desktop"
        "foot.desktop"
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
