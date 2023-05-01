{ pkgs, extras, config, lib, ... }:
let
  inherit (extras) pkgsUnstable;
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/poetry/default.nix#L40
  poetry = pkgsUnstable.poetry.withPlugins (pluginSelector: with pluginSelector; [ poetry-plugin-up ]);
in
{
  environment.systemPackages = (with pkgs; [
    exiftool
    fontforge
    unpaper
  ]) ++ (with pkgsUnstable; [
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
    plantuml
    pre-commit
    python3Full
    ruff
    speedtest-cli
    youtube-dl
  ]) ++ ([
    poetry
  ]);
}
