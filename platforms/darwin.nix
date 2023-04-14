{ pkgs, ... }:
{
  imports = [ ./base.nix ];
  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;
}
