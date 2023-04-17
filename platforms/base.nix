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

  nix.package = pkgs.nix;
}
