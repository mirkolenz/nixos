{
  pkgs,
  lib,
  ...
}: let
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/poetry/default.nix#L40
  poetry = pkgs.poetry.withPlugins (ps: with ps; [poetry-plugin-up]);
in {
  imports = [
    ./commands.nix
    ./darwin.nix
    ./linux.nix
    ./workstation.nix
  ];
  home.packages = with pkgs; [
    bashInteractive
    zsh
    fish
    coreutils-full
    findutils
    gnused
    gnupg
    gnupatch
    gnugrep
    gnutar
    gnumake
    gcc
    zip
    unzip
    bat
    exa
    fd
    procs
    sd
    ripgrep
    tealdeer
    bandwhich
    delta
    fzf
    massren
    rsync
    curl
    wget
    mu-repo
    nixpkgs-fmt
    nil
    nixfmt
    alejandra
    poetry
    mkpasswd
    macchina
  ];
  home.shellAliases = {
    poetryup = "${lib.getExe poetry} up";
    py = "poetry run python"; # should use local poetry if possible
    npmup = lib.getExe pkgs.nodePackages.npm-check-updates;
  };
}
