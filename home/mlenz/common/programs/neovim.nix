{
  pkgs,
  config,
  lib,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = pkgs.nixvim-unstable;
  };
  programs.neovide = {
    enable = config.custom.profile.isDesktop;
    settings = {
      fork = true;
      neovim-bin = if pkgs.stdenv.isDarwin then "${config.home.homeDirectory}/bin" else lib.getExe config.custom.neovim.package;
    };
  };
}
