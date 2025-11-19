{ pkgs, ... }:
{
  programs = {
    # bash is enabled by default
    fish = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
  };
  environment.shells = with pkgs; [ fish ];
  environment.pathsToLink = [
    "/share/bash-completion"
    "/share/fish"
    "/share/zsh"
  ];
}
