{
  pkgs,
  lib,
  ...
}:
{
  programs.tmux = {
    enable = false;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = lib.getExe pkgs.fish;
    shortcut = "a";
    terminal = "xterm-256color";
  };
}
