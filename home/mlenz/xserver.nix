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
  keybindings = [
    {
      binding = "<Super>space";
      command = lib.getExe' pkgs.ulauncher "ulauncher-toggle";
      name = "ulauncher";
    }
  ];
  # https://github.com/nix-community/home-manager/blob/master/modules/lib/gvariant.nix
  gv = lib.hm.gvariant;
in
lib.mkIf xserverEnabled {
  home.packages =
    gnomeExtensions
    ++ (with pkgs; [
      inter
      jetbrains-mono
    ]);
  home.file.".face".source = builtins.fetchurl {
    url = "https://github.com/mirkolenz.png";
    sha256 = "1cyxw64xvpgb0kzdp73a1xvrqv5ik1fgkn9qnh6k2kry2w4r7gra";
  };
  gtk = {
    enable = true;
    cursorTheme.name = "Adwaita";
    iconTheme.name = "Adwaita";
    theme.name = "Adwaita";
  };
  # https://github.com/gvolpe/dconf2nix
  # dconf watch /
  dconf.settings =
    {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (ext: ext.extensionUuid) gnomeExtensions;
        favorite-apps = map (x: "${x}.desktop") [
          "org.gnome.Nautilus"
          "1password"
          "google-chrome"
          "Zoom"
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
        font-hinting = "full";
        font-name = "Inter 11";
        document-font-name = "Inter 11";
        monospace-font-name = "JetBrains Mono 11";
        titlebar-font = "Inter Bold 11";
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
        dash-max-icon-size = 42;
        height-fraction = 1.0;
        dock-fixed = false;
        autohide-in-fullscreen = true;
        require-pressure-to-show = true;
        intellihide = false;
        animation-time = 5.0e-2;
        hide-delay = 0.2;
        pressure-threshold = 10.0;
        custom-theme-shrink = false;
        disable-overview-on-startup = true;
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
      "org/gnome/desktop/wm/kebindings" = {
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings =
          lib.imap0
            (idx: _: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString idx}/")
            keybindings;
      };
    }
    // (lib.listToAttrs (
      lib.imap0
        (idx: value: {
          inherit value;
          name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString idx}";
        })
        keybindings
    ));
}
