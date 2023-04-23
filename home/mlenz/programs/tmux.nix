{ osConfig, pkgs, lib, ... }:
{
  programs.tmux = {
    enable = pkgs.stdenv.isLinux && osConfig.services.openssh.enable;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = "${pkgs.fish}/bin/fish";
    shortcut = "a";
    terminal = "xterm-256color";
  };
}
