{ pkgs, osConfig, ... }:
{

  programs.zellij = {
    enable = pkgs.stdenv.isLinux && (osConfig.services.openssh.enable or true);
    # enableBashIntegration = false;
    # enableFishIntegration = false;
    # enableZshIntegration = false;
    attachExistingSession = true; # requires shell integration
    exitShellOnExit = true; # requires shell integration
    settings = {
      auto_layout = true;
      default_layout = "default";
      default_mode = "normal";
      on_force_close = "detach";
      show_release_notes = false;
      show_startup_tips = false;
      theme = "default";
    };
  };
}
