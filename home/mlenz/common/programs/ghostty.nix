{
  pkgs,
  lib,
  config,
  ...
}:
let
  mkSettings = lib.mapAttrs (
    _: value:
    if lib.isList value then
      lib.concatStringsSep "," value
    else if lib.isAttrs value then
      lib.concatMapAttrsStringSep "," (k: v: "${k}:${v}") value
    else
      value
  );
in
{
  programs.ghostty = lib.mkIf config.custom.profile.isDesktop {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
    settings = mkSettings {
      cursor-click-to-move = true;
      font-family = "JetBrainsMono Nerd Font";
      font-size = if pkgs.stdenv.isDarwin then 13 else 11;
      font-thicken = true;
      shell-integration = "none";
      shell-integration-features = [
        "no-cursor"
        "sudo"
        "title"
      ];
      theme = {
        light = "GitHub-Light-Default";
        dark = "GitHub-Dark-Default";
      };
      window-height = 30;
      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 120;
    };
  };
  programs.ssh.extraConfig = ''
    SetEnv TERM=xterm-256color
  '';
}
