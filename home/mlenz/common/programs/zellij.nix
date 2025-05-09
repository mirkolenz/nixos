{ pkgs, osConfig, ... }:
{

  programs.zellij = {
    enable = pkgs.stdenv.isLinux && (osConfig.services.openssh.enable or true);
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    # only works if shell integration is enabled
    # attachExistingSession = true;
    # exitShellOnExit = true;
    settings = {
      auto_layout = true;
      default_layout = "default";
      on_force_close = "detach";
    };
  };
}
