{ pkgs, extras, config, lib, ... }:
let
  inherit (extras) unstable;
in
{
  environment.systemPackages = (with pkgs; [
    exiftool
    fontforge
    unpaper
  ]) ++ (with unstable; [
    # TODO: dvc
    _1password
    black
    buf
    gomplate
    gradle
    grpcui
    home-assistant-cli
    mqttui
    nodejs
    nodePackages.prettier
    ocrmypdf
    pandoc
    plantuml
    poetry
    poetryPlugins.poetry-plugin-up
    pre-commit
    python3Full
    ruff
    speedtest-cli
    youtube-dl
    # TODO: texlive.combined.scheme-full
  ]);
}
