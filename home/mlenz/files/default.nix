{
  lib,
  pkgs,
  config,
  inputs,
  osConfig,
  ...
}: let
  poetryPrefix =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/pypoetry"
    else "${config.xdg.configHome}/pypoetry";
in {
  home.file = {
    "${poetryPrefix}/config.toml" = {
      source = ./poetry.toml;
    };
    ".mackup.cfg" = lib.mkIf pkgs.stdenv.isDarwin {
      source = ./.mackup.cfg;
    };
    ".amethyst.yml" = lib.mkIf pkgs.stdenv.isDarwin {
      source = ./.amethyst.yml;
    };
  };
  xdg = {
    configFile = {
      # https://nix-community.github.io/home-manager/options.html#opt-nixpkgs.config
      "nixpkgs/config.nix".source = ../../../nixpkgs-config.nix;
      "macchina/themes/custom.toml".source = ./macchina-theme.toml;
      "macchina/macchina.toml".source = ./macchina-config.toml;
    };
  };
}
