{
  pkgs,
  lib,
  config,
  ...
}:
let
  pythonWithPackages = pkgs.python3.withPackages (ps: with ps; [ typer ]);
in
lib.mkIf config.custom.profile.isWorkstation {
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
    ghostscript
    janice
    harper
    protobuf-ls
    # typst
    typst
    typstyle
    tinymist
    # nix
    nixd
    nixfmt
    alejandra
    nix-update
    nvfetcher
    devenv
    nurl
    hydra-check
    nixos-render-docs
    nix-converter
    # go
    go
    gopls
    delve
    go-outline
    goreleaser
    # python
    pythonWithPackages
    pylyzer
    basedpyright
    ty-bin
    # pyrefly
    # nodejs
    nodejs
    nodePackages.prettier
    nodePackages.dotenv-vault
    npm-check-updates
    biome
    # java
    jdk
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
  ];
}
