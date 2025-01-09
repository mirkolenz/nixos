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
  };
  home.packages = with pkgs; [
    shpool
  ];
}
