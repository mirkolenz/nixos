{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    texliveFull
    tectonic
    texlab
    bibtex2cff
    bibtex-to-cff
    mas
  ];
}
