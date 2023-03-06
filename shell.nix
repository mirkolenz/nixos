{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    # needed by nix
    nixpkgs-fmt
    nil
    rnix-lsp
    git
  ];
}
