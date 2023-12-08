{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/poetry/default.nix#L40
  poetry = pkgs.poetry.withPlugins (ps: with ps; [poetry-plugin-up]);
in
  lib.mkIf (pkgs.stdenv.isDarwin || (lib.attrByPath ["services" "xserver" "enable"] true osConfig)) {
    home.packages = with pkgs; [
      exiftool
      fontforge
      unpaper
      _1password
      buf
      stable.dvc
      gomplate
      grpcui
      mqttui
      plantuml
      pre-commit
      mu-repo
      youtube-dl
      cc2538-bsl
      imagemagick
      pngquant
      # nix
      nixpkgs-fmt
      nil
      nixd
      nixfmt
      alejandra
      nix-update
      nvfetcher
      # go
      go
      gopls
      delve
      go-outline
      goreleaser
      # python
      poetry
      python3Full
      ruff
      black
      # nodejs
      nodejs
      nodePackages.prettier
      nodePackages.dotenv-vault
      # java
      jdk
      gradle
      # my own packages
      makejinja
      arguebuf
      (writeShellScriptBin "poetryup" ''exec ${lib.getExe poetry} up "$@"'')
      (writeShellScriptBin "npmup" nodePackages.npm-check-updates)
    ];
  }
