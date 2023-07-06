{
  pkgs,
  lib,
  osConfig,
  flakeInputs,
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
    nodePackages.dotenv-vault
    ocrmypdf
    plantuml
    pre-commit
    python3Full
    ruff
    speedtest-cli
    youtube-dl
    cc2538-bsl
    makejinja
    arguebuf
  ];

  home.shellAliases = {
    hass = "${pkgs.home-assistant-cli}/bin/hass-cli";
  };
}
