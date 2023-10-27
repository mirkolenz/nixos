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
    # TODO: Causes signal SIGSEGV (Address boundary error)
    # https://github.com/nix-community/poetry2nix/issues/1291
    # bibtex2cff
    bibtex-to-cff
  ];
}
