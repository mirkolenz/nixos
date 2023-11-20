{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    texliveFull
    stable.tectonic
    texlab
    bibtex2cff
    bibtexbrowser2cff
    mas
    (pkgs.writeShellApplication {
      name = "bibcopy";
      text = ''
        if [ "$#" -lt 1 ]; then
          echo "Usage: $0 FORMAT (biblatex/bibtex) [SOURCE_DIR] [TARGET_DIR]" >&2
          exit 1
        fi
        sourceDir="''${2:-${config.home.homeDirectory}/Developer/mirkolenz/bibliography}"
        targetDir="''${3:-.}"
        cp -f "$sourceDir/$1.bib" "$targetDir/references.bib"
        cp -f "$sourceDir/acronyms.tex" "$targetDir/acronyms.tex"
      '';
    })
  ];
}
