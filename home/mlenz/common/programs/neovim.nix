{
  pkgs,
  config,
  lib,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = pkgs.nixvim;
  };
  programs.neovide = {
    enable = config.custom.profile.isDesktop;
    settings = {
      fork = true;
      neovim-bin = lib.getExe config.custom.neovim.package;
    };
  };
  home.packages = lib.mkIf config.programs.neovide.enable [
    pkgs.neovide-launcher
  ];
}
