{
  pkgs,
  lib,
  config,
  ...
}:
let
  pythonWithPackages = pkgs.python3.withPackages (ps: with ps; [ typer ]);
in
lib.mkIf (config.custom.profile == "workstation") {
  home.sessionVariables = {
    RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
    EDITOR = "zed -w";
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
    comrak
    mdbook
    treefmt-nix
    uv-migrator
    llm
    catppuccin-whiskers
    # python3Packages.markitdown # fails on darwin
    # typst
    typst
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
    nixos-render-docs
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
    pylyzer
    basedpyright
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
    # language servers
    taplo
    # my own packages
    makejinja
    arguebuf
    (writeShellScriptBin "npmup" ''exec ${lib.getExe npm-check-updates} "$@"'')
  ];
}
