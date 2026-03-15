{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    package = if config.custom.features.withOptionals then pkgs.nixvim-full else pkgs.nixvim-minimal;
    defaultEditor = true;
  };
  programs.neovide = lib.mkIf config.custom.features.withDisplay {
    enable = true;
    settings = {
      fork = true;
      neovim-bin = lib.getExe config.programs.nixvim.package;
      no-multigrid = true;
    };
  };
}
