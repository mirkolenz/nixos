{ pkgs, extras, ... }:
let
  inherit (extras) unstable;
in
{
  imports = [
    ./users.nix
    ./shell.nix
    ../../home
  ];

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

  nix = {
    package = pkgs.nix;
  };
}
