{ lib, pkgs, ... }:
{
  home.file = {
    ".mackup.cfg" = lib.mkIf pkgs.stdenv.isDarwin { source = ./.mackup.cfg; };
    ".amethyst.yml" = lib.mkIf pkgs.stdenv.isDarwin { source = ./.amethyst.yml; };
  };
  xdg = {
    configFile = {
      "macchina/themes/custom.toml".source = ./macchina-theme.toml;
      "macchina/macchina.toml".source = ./macchina-config.toml;
    };
  };
}
