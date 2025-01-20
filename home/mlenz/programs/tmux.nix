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
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      auto_layout = true;
      default_layout = "default";
      on_force_close = "detach";
      theme = "default";
    };
  };
  home.sessionVariables = {
    ZELLIJ_AUTO_ATTACH = "1";
    ZELLIJ_AUTO_EXIT = "0";
  };
  home.packages = lib.mkIf opensshEnabled (
    with pkgs;
    [
      shpool
    ]
  );
}
