{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
let
  python = pkgs.python3.withPackages (ps: with ps; [ typer ]);
in
lib.mkIf (pkgs.stdenv.isDarwin || (osConfig.services.xserver.enable or false)) {
  home.sessionVariables = {
    RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
  };
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
    yt-dlp
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
    # rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    # my own packages
    makejinja
    arguebuf
    (writeShellScriptBin "poetryup" ''exec ${lib.getExe config.programs.poetry.package} up "$@"'')
    (writeShellScriptBin "npmup" ''exec ${lib.getExe npm-check-updates} "$@"'')
  ];
}
