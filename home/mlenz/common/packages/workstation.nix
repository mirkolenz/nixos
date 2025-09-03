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
    EDITOR = "zed --wait";
  };
  programs = {
    gradle.enable = true;
    mods.enable = true;
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
    touying
    mcp-proxy
    # typst
    typst
    typstyle
    tinymist
    # presentation
    pdfpc
    pympress
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
    nix-sweep
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
    uv-apps
    # nodejs
    nodejs
    prettier
    npm-check-updates
    biome
    bun
    bun-apps
    # java
    jdk
    # rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    # language servers
    tombi
    copilot-language-server
    # my own packages
    makejinja
  ];
}
