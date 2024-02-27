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
  # https://github.com/nix-community/home-manager/blob/master/modules/lib/gvariant.nix
  gv = lib.hm.gvariant;
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
  # https://github.com/gvolpe/dconf2nix
  # dconf watch /
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (ext: ext.extensionUuid) gnomeExtensions;
      favorite-apps = map (x: "${x}.desktop") [
        "org.gnome.Nautilus"
        "1password"
        "google-chrome"
        "code"
        "org.gnome.Console"
        "org.gnome.Settings"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      enable-hot-corners = false;
      font-aliasing = "rgba";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      multi-monitor = true;
      dock-position = "BOTTOM";
      dash-max-icon-size = 32;
      dock-fixed = false;
      autohide-in-fullscreen = true;
      require-pressure-to-show = true;
      intellihide = false;
      animation-time = 5.0e-2;
      hide-delay = 0.2;
      pressure-threshold = 10.0;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = gv.mkUint32 2000;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.3;
      tap-to-click = true;
      natural-scroll = true;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      clock-show-weekday = true;
      clock-show-date = true;
      clock-show-seconds = true;
      clock-show-week-numbers = false;
    };
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
