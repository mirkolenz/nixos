{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nixpkgs-fmt
    nil
    rnix-lsp
    git
  ];
}
