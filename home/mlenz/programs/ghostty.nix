{
  pkgs,
  lib,
  config,
  osConfig,
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
  settings = mkSettings {
    cursor-click-to-move = true;
    font-family = "Berkeley Mono";
    font-size = if pkgs.stdenv.isDarwin then 13 else 12;
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
in
{
  programs.ghostty-custom = {
    inherit settings;
    enable = pkgs.stdenv.isDarwin;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
  programs.ghostty = {
    inherit settings;
    enable = pkgs.stdenv.isLinux && (osConfig.services.xserver.enable or false);
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.ssh.matchBlocks."*".extraOptions = lib.mkIf config.programs.ghostty-custom.enable {
    SetEnv = "TERM=xterm-256color";
  };
}
