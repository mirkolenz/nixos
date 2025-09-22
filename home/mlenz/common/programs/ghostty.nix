{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.ghostty = lib.mkIf config.custom.profile.isDesktop {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
    # https://ghostty.org/docs/config/reference
    settings = {
      auto-update = "download";
      auto-update-channel = "stable";
      cursor-click-to-move = true;
      font-family = "JetBrainsMono Nerd Font";
      font-size = if pkgs.stdenv.isDarwin then 13 else 11;
      font-thicken = true;
      quick-terminal-position = "center";
      quick-terminal-size = "1000px,600px";
      shell-integration = "none";
      shell-integration-features = "no-cursor,sudo,title,ssh-env";
      theme = "light:GitHub Light Default,dark:GitHub Dark Default";
      window-height = 30;
      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 120;
      keybind = [
        "global:alt+backquote=toggle_quick_terminal"
      ];
    };
  };
}
