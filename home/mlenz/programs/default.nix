{extras, ...}: let
  inherit (extras) user;
in {
  imports = [
    ./bottom.nix
    ./fish.nix
    ./git.nix
    ./hyfetch.nix
    ./micro.nix
    ./nixvim.nix
    ./pandoc.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
  ];

  programs = {
    home-manager.enable = true;
    htop = {
      enable = true;
    };
    btop = {
      enable = true;
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
    };
    bash = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    nix-index = {
      enable = true;
    };
    bat = {
      enable = true;
    };
  };
}
