{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  networking.networkmanager.enable = true;

  users.defaultUserShell = pkgs.fish;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  system = {
    stateVersion = "22.11";
  };
}
