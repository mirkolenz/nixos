{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  opensshEnabled = pkgs.stdenv.isLinux && (osConfig.services.openssh.enable or true);
in
{
  programs.tmux = {
    enable = opensshEnabled;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = lib.getExe pkgs.fish;
    shortcut = "a";
    terminal = "xterm-256color";
  };
  programs.zellij = {
    enable = opensshEnabled;
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
  home.packages = lib.mkIf opensshEnabled (
    with pkgs;
    [
      shpool
    ]
  );
}
