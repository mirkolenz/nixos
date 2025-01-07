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
  programs.ghostty-custom = {
    enable = pkgs.stdenv.isDarwin;
    settings = mkSettings {
      cursor-click-to-move = true;
      font-family = "Berkeley Mono";
      font-size = 13;
      font-thicken = true;
      shell-integration = "none";
      shell-integration-features = [
        "no-cursor"
        "sudo"
        "title"
      ];
      theme = {
        dark = "GitHub Dark";
        light = "GitHub";
      };
      window-height = 30;
      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 120;
    };
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.ssh.matchBlocks."*".extraOptions = lib.mkIf config.programs.ghostty-custom.enable {
    SetEnv = "TERM=xterm-256color";
  };
}
