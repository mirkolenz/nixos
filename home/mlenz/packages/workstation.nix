{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  python = pkgs.python3.withPackages (ps: with ps; [ typer ]);
in
lib.mkIf (pkgs.stdenv.isDarwin || (osConfig.services.xserver.enable or false)) {
  home.packages = with pkgs; [
    exiftool
    fontforge
    unpaper
    buf
    dvc
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
    python
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
    (writeShellScriptBin "npmup" ''exec ${lib.getExe nodePackages.npm-check-updates} "$@"'')
  ];
}
