{ pkgs, extras, ... }:
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
  environment.shellAliases = {
    dc = "docker compose";
    ls = "exa";
    ll = "exa -l";
    la = "exa -la";
    l = "exa -l";
  };
}
