{
  config,
  lib,
  ...
}:
{
  programs.zellij = lib.mkMerge [
    {
      enable = true;
      settings = {
        auto_layout = true;
        default_layout = "default";
        default_mode = "normal";
        on_force_close = "detach";
        session_serialization = false;
        show_release_notes = false;
        show_startup_tips = false;
        theme = "default";
      };
    }
    (lib.mkIf config.custom.profile.isServer {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      attachExistingSession = true; # requires shell integration
      exitShellOnExit = true; # requires shell integration
    })
  ];
}
