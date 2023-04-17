{ pkgs, extras, ... }:
{
  imports = [ ./base.nix ];

  networking.networkmanager.enable = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker = {
    enable = true;
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
  };

  # Currently produces an error on darwin
  # https://github.com/LnL7/nix-darwin/issues/359
  time.timeZone = "Europe/Berlin";

  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    mkpasswd
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
