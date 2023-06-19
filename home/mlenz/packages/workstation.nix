{
  pkgs,
  lib,
  osConfig,
  ...
}:
lib.mkIf (pkgs.stdenv.isDarwin || (lib.attrByPath ["services" "xserver" "enable"] true osConfig)) {
  home.packages = with pkgs; [
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
  ];

  home.shellAliases = {
    hass = "${pkgs.home-assistant-cli}/bin/hass-cli";
  };
}
