{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [
    texlive.combined.scheme-full
    tectonic
    texlab
    bibtex2cff
    bibtex-to-cff
  ]);
}
