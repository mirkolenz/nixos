{ lib, pkgs, config, extras, ... }:
let
  poetryPrefix = if pkgs.stdenv.isDarwin then "Library/Preferences/pypoetry" else "${config.xdg.configHome}/pypoetry";
in
{
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
    "${config.xdg.configHome}/macchina/themes" = {
      source = "${extras.inputs.macchina.outPath}/contrib/themes";
    };
  };
}
