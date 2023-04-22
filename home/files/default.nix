{ lib, pkgs, config, ... }:
let
  inherit (pkgs) stdenv;
  poetryPrefix = if stdenv.isDarwin then "Library/Preferences/pypoetry" else "${config.xdg.configHome}/pypoetry";
in
{
  home.file = {
    "${poetryPrefix}/config.toml".source = ./poetry.toml;
    ".latexmkrc".source = ./.latexmkrc;
    ".mackup.cfg".source = lib.mkIf stdenv.isDarwin ./.mackup.cfg;
  };
}
