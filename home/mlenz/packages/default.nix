{
  pkgs,
  lib,
  ...
}: let
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/poetry/default.nix#L40
  poetry = pkgs.poetry.withPlugins (pluginSelector: with pluginSelector; [poetry-plugin-up]);
in {
  imports = [
    ./commands.nix
    ./darwin.nix
    ./linux.nix
    ./workstation.nix
  ];
  home.packages = with pkgs; [
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
    gnumake
    massren
    rsync
    curl
    wget
    gnugrep
    gnutar
    direnv
    nix-direnv
    zip
    unzip
    coreutils
    mu-repo
    nixpkgs-fmt
    nil
    nixfmt
    alejandra
    poetry
  ];
  home.shellAliases = {
    poetryup = "${lib.getExe poetry} up";
    py = "poetry run python"; # should use local poetry if possible
    npmup = lib.getExe pkgs.nodePackages.npm-check-updates;
  };
}
