{
  pkgs,
  extras,
  lib,
  ...
}: let
  inherit (extras) pkgsUnstable;
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/poetry/default.nix#L40
  poetry = pkgsUnstable.poetry.withPlugins (pluginSelector: with pluginSelector; [poetry-plugin-up]);
in {
  environment.systemPackages =
    (with pkgs; [
      exiftool
      fontforge
      unpaper
    ])
    ++ (with pkgsUnstable; [
      _1password
      black
      buf
      # dvc
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
    ])
    ++ [
      poetry
    ];

  environment.shellAliases = {
    poetryup = "${lib.getExe poetry} up";
    py = "poetry run python"; # should use local poetry if possible
    npmup = lib.getExe pkgsUnstable.nodePackages.npm-check-updates;
    hass = "${pkgsUnstable.home-assistant-cli}/bin/hass-cli";
  };
}
