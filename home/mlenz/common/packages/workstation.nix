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
    go.enable = true;
    gradle.enable = true;
    java.enable = true;
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
    poppler-utils
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
    protobuf-language-server
    touying
    mcp-proxy
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
    gopls
    delve
    go-outline
    goreleaser
    # python
    pythonWithPackages
    pylyzer
    basedpyright
    zuban
    # other apps
    uv-apps
    bun-apps
    # rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    # language servers
    copilot-language-server
    jdt-language-server
    tombi
    # my own packages
    makejinja
  ];
}
