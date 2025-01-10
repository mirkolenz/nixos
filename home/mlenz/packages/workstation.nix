{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  pythonWithPackages = pkgs.python3.withPackages (ps: with ps; [ typer ]);
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
    poppler_utils
    ffmpeg
    ffmpeg-normalize
    qpdf
    # python3Packages.markitdown # fails on darwin
    # typst
    typst
    typst-lsp
    typstyle
    tinymist
    # nix
    nil
    nixd
    nixfmt
    alejandra
    nix-update
    nvfetcher
    devenv
    nurl
    nix-init
    hydra-check
    # go
    go
    gopls
    delve
    go-outline
    goreleaser
    # python
    pythonWithPackages
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
    # arguebuf
    (writeShellScriptBin "npmup" ''exec ${lib.getExe npm-check-updates} "$@"'')
  ];
}
