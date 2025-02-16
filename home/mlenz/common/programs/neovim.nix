{
  pkgs,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = pkgs.nixvim-unstable;
  };
}
