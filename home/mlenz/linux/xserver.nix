{
  lib,
  pkgs,
  config,
  cosmicLib,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  home.packages = with pkgs; [
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
  home.file.".face".source = ../mlenz.jpg;
  wayland.desktopManager.cosmic = {
    enable = true;
    appearance.theme.mode = "dark";
    wallpapers = [
      {
        output = "all";
        source = cosmicLib.cosmic.mkRON "enum" {
          variant = "Color";
          value = [
            (cosmicLib.cosmic.mkRON "enum" {
              variant = "Single";
              value = [
                (cosmicLib.cosmic.mkRON "tuple" [
                  0.0
                  0.0
                  0.0
                ])
              ];
            })
          ];
        };
      }
    ];
    applets.app-list.settings = {
      enable_drag_source = true;
      favorites = [
        "com.system76.CosmicFiles"
        "vivaldi"
        "1password"
        "obsidian"
        "code"
        "com.system76.CosmicEdit"
        "com.mitchellh.ghostty"
        "zotero"
        "Zoom"
        "com.system76.CosmicSettings"
      ];
      filter_top_levels = null;
    };
  };
  programs = {
    cosmic-applibrary = {
      enable = true;
      settings.groups = [ ];
    };
    cosmic-edit = {
      enable = true;
    };
    cosmic-files = {
      enable = true;
    };
    cosmic-player = {
      enable = true;
    };
    cosmic-store = {
      enable = false;
    };
    cosmic-term = {
      enable = false;
    };
    forecast = {
      enable = false;
    };
    tasks = {
      enable = false;
    };
  };
}
