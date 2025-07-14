{
  pkgs,
  config,
  lib,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = if config.custom.profile.isWorkstation then pkgs.nixvim-full else pkgs.nixvim-minimal;
  };
  programs.neovide = {
    enable = config.custom.profile.isDesktop;
    settings = {
      fork = true;
      neovim-bin = lib.getExe config.custom.neovim.package;
      no-multigrid = true;
    };
  };
}
