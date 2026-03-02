{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = lib.mkDefault (pkgs.stdenv.isLinux && config.custom.profile.isDesktop);
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
