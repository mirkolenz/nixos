{ pkgs, extras, ... }:
let
  inherit (extras) pkgsUnstable;
in
{
  imports = [
    ./homebrew.nix
    ./settings.nix
  ];

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  environment.systemPackages = with pkgsUnstable; [
    texlive.combined.scheme-full
  ];
}
