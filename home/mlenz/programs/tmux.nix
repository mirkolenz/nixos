{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = pkgs.stdenv.isLinux && osConfig.services.openssh.enable;
    clock24 = true;
    keyMode = "vi";
    # TODO: new in 23.05 mouse = true;
    newSession = true;
    shell = lib.getExe pkgs.fish;
    shortcut = "a";
    terminal = "xterm-256color";
  };
}
