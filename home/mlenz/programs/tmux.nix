{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  opensshEnabled = pkgs.stdenv.isLinux && (lib.attrByPath ["services" "openssh" "enable"] true osConfig);
in {
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
}
