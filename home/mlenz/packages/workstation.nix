{
  pkgs,
  pkgsUnstable,
  pkgsStable,
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
      # dvc
      pkgsStable.gomplate
      grpcui
      mqttui
      ocrmypdf
      plantuml
      pre-commit
      mu-repo
      youtube-dl
      cc2538-bsl
      # nix
      nixpkgs-fmt
      nil
      pkgsUnstable.nixd
      nixfmt
      alejandra
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
      makejinja
      arguebuf
    ];
    home.shellAliases = {
      hass = lib.getExe pkgs.home-assistant-cli;
      poetryup = "${lib.getExe poetry} up";
      npmup = lib.getExe pkgs.nodePackages.npm-check-updates;
    };
  }
