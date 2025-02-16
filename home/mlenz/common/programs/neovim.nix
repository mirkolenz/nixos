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
      neovim-bin = "${config.home.homeDirectory}/bin/nvim";
    };
  };
  # makes it easier/faster to link a new neovim binary
  programs.fish.loginShellInit = ''
    fish_add_path "${config.home.homeDirectory}/bin"
  '';
  home.activation.linkNixvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe pkgs.link-nixvim} $VERBOSE_ARG
  '';
}
