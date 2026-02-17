{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf (pkgs.stdenv.isLinux && config.custom.profile.isDesktop) {
  programs.zed-editor = {
    enable = true;
    mutableUserDebug = false;
    mutableUserKeymaps = false;
    mutableUserSettings = false;
    mutableUserTasks = false;
  };
  xdg.configFile = {
    "zed/debug.json".source = ./debug.json;
    "zed/keymap.json".source = ./keymap.json;
    "zed/settings.json".source = ./settings.json;
    "zed/tasks.json".source = ./tasks.json;
  };
}
