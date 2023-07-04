{
  lib,
  pkgs,
  config,
  flakeInputs,
  ...
}: let
  inherit (flakeInputs) macchina texmf;
  poetryPrefix =
    if pkgs.stdenv.isDarwin
    then "Library/Preferences/pypoetry"
    else "${config.xdg.configHome}/pypoetry";
in {
  home.file = {
    "${poetryPrefix}/config.toml" = {
      source = ./poetry.toml;
    };
    ".latexmkrc" = {
      source = ./.latexmkrc;
    };
    ".mackup.cfg" = lib.mkIf pkgs.stdenv.isDarwin {
      source = ./.mackup.cfg;
    };
    ".amethyst.yml" = lib.mkIf pkgs.stdenv.isDarwin {
      source = ./.amethyst.yml;
    };
    "${config.xdg.configHome}/macchina/themes" = {
      source = "${macchina}/contrib/themes";
    };
    # TODO: Make dependent on texlive (currently installed only on darwin)
    "${config.home.homeDirectory}/texmf" = lib.mkIf pkgs.stdenv.isDarwin {
      source = texmf;
    };
  };
  xdg = {
    configFile = {
      # https://nix-community.github.io/home-manager/options.html#opt-nixpkgs.config
      "nixpkgs/config.nix".source = ../../../nixpkgs-config.nix;
    };
  };
}
