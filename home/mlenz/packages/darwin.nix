{
  pkgs,
  lib,
  config,
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
    (pkgs.writeShellApplication {
      name = "bibcopy";
      text = ''
        if [ "$#" -ne 1 ]; then
          echo "Usage: $0 FORMAT (biblatex or bibtex)" >&2
          exit 1
        fi
        exec cp -f "${config.home.homeDirectory}/Developer/mirkolenz/bibliography/references-$1.bib" "references.bib"
      '';
    })
    (pkgs.writeShellApplication {
      name = "acrocopy";
      text = ''
        exec cp -f "${config.home.homeDirectory}/Developer/mirkolenz/bibliography/acro.tex" "acro.tex"
      '';
    })
  ];
}
