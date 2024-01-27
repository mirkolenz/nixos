{
  lib,
  pkgs,
  config,
  ...
}:
let
  poetryPrefix =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/pypoetry"
    else
      "${config.xdg.configHome}/pypoetry";
in
{
  home.file = {
    "${poetryPrefix}/config.toml".source = ./poetry.toml;
    ".mackup.cfg".source = lib.mkIf pkgs.stdenv.isDarwin ./.mackup.cfg;
    ".amethyst.yml".source = lib.mkIf pkgs.stdenv.isDarwin ./.amethyst.yml;
  };
  xdg = {
    configFile = {
      "macchina/themes/custom.toml".source = ./macchina-theme.toml;
      "macchina/macchina.toml".source = ./macchina-config.toml;
    };
  };
}
