{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf (config.custom.profile == "workstation") {
  home.packages = with pkgs; [
    inter
    jetbrains-mono
  ];
  home.file.".face".source = ../mlenz.jpg;
  wayland.desktopManager.cosmic = {
    enable = true;
    appearance.theme.mode = "dark";
    applets.app-list = {
      enable_drag_source = true;
      favorites = [
        "com.system76.CosmicFiles"
        "google-chrome"
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
