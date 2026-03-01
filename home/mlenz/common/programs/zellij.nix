{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      auto_layout = true;
      default_layout = "default";
      default_mode = "normal";
      on_force_close = "quit";
      session_serialization = false;
      show_release_notes = false;
      show_startup_tips = false;
      theme = "default";
    };
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    attachExistingSession = false;
    exitShellOnExit = true;
  };
}
