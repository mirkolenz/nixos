{ pkgs, extras, ... }:
let
  inherit (extras) unstable;
in
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
    bash = {
      # enable = true; # no longer needed
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
    mkpasswd
    massren
    poetry
    unstable.buf
  ];
  environment.shells = with pkgs; [ fish ];

  nix.package = pkgs.nix;
}
