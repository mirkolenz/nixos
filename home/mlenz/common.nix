{ lib, config, osConfig, pkgs, extras, ... }:
let
  inherit (pkgs) stdenv;
  inherit (extras) username;
  homeDirectory = if stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in {
  imports = [
    ../programs/fish.nix
    ../programs/micro.nix
    ../programs/neovim.nix
    ../programs/git.nix
    ../programs/ssh.nix
    ../files
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    inherit username;
    inherit (extras) stateVersion;
    homeDirectory = lib.mkDefault homeDirectory;
  };
  programs = {
    home-manager.enable = true;
    htop = {
      enable = true;
    };
    # texlive = {
    #   enable = true;
    # };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
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
  };
}
