{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    package = if config.custom.profile.isWorkstation then pkgs.nixvim-full else pkgs.nixvim-minimal;
    defaultEditor = true;
  };
  programs.neovide = lib.mkIf config.custom.profile.isDesktop {
    enable = true;
    settings = {
      fork = true;
      neovim-bin = lib.getExe config.programs.nixvim.package;
      no-multigrid = true;
    };
  };
}
