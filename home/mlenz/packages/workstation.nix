{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  enable = pkgs.stdenv.isDarwin || (lib.attrByPath ["services" "xserver" "enable"] true osConfig);
in {
  home.packages = lib.mkIf enable (with pkgs; [
    exiftool
    fontforge
    unpaper
    _1password
    black
    buf
    # dvc
    gomplate
    gradle
    grpcui
    mqttui
    nodejs
    nodePackages.prettier
    ocrmypdf
    plantuml
    pre-commit
    python3Full
    ruff
    speedtest-cli
    youtube-dl
    cc2538-bsl
  ]);

  home.shellAliases = {
    hass = "${pkgs.home-assistant-cli}/bin/hass-cli";
  };
}
