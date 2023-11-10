{
  pkgs,
  pkgsStable,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    pkgsStable.texlive.combined.scheme-full
    tectonic
    texlab
    bibtex2cff
    bibtex-to-cff
    mas
  ];
}
