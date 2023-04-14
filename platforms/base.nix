{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
    };
    git = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  users = {
    mutableUsers = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [ mkpasswd ];
  environment.shells = with pkgs; [ fish ];

  nix.package = pkgs.nix;
}
