{ pkgs, ... }:
{
  programs.ruff = {
    enable = true;
    package = pkgs.ruff-bin;
    settings = { };
  };
}
