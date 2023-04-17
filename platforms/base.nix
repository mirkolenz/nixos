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

  users = {
    mutableUsers = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    curl
    exa
    fd
    gnumake
    massren
    mkpasswd
    ripgrep
    rsync
    wget
  ];
  environment.shells = with pkgs; [ fish ];

  nix.package = pkgs.nix;
}
