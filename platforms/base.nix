{ pkgs, extras, ... }:
let
  inherit (extras) unstable;
in
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

  environment.systemPackages = with pkgs; [
    curl
    exa
    fd
    gnumake
    massren
    ripgrep
    rsync
    wget
  ];
  environment.shells = with pkgs; [ fish ];

  environment.shellAliases = {
    dc = "docker compose";
    ls = "exa";
    ll = "exa -l";
    la = "exa -la";
    l = "exa -l";
  };

  nix.package = pkgs.nix;
}
