{ pkgs, extras, ... }:
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

  environment.defaultPackages = with pkgs; [
    neovim
    rsync
    python3Minimal
    strace
  ];

  system = {
    inherit (extras) stateVersion;
  };
}
