{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  programs.tmux = {
    enable = pkgs.stdenv.isLinux && (osConfig.services.openssh.enable or true);
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = lib.getExe pkgs.fish;
    shortcut = "a";
    terminal = "xterm-256color";
  };
}
