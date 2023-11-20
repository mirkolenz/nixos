{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    mas
    texliveFull
    stable.tectonic
    texlab
    bibtex2cff
    bibtexbrowser2cff
    bibtex-tidy
    (pkgs.writeShellApplication {
      name = "bibtidy";
      text = let
        maxAuthors = 10;
        omitFields = [
          "abstract"
          "address"
          "annotation"
          "archiveprefix"
          "doi"
          "editor"
          "eprint"
          "isbn"
          "issn"
          "primaryclass"
          "url"
          "urldate"
        ];
      in ''
        ${lib.getExe pkgs.bibtex-tidy} --v2 \
          --no-align --no-wrap --blank-lines --no-escape \
          --omit="${lib.concatStringsSep "," omitFields}" \
          --max-authors="${builtins.toString maxAuthors}" \
          "$@"
      '';
    })
    (pkgs.writeShellApplication {
      name = "bibcopy";
      text = ''
        format="''${1:-bibtex}"
        sourceDir="''${2:-${config.home.homeDirectory}/Developer/mirkolenz/bibliography}"
        targetDir="''${3:-.}"
        bibtidy --output="$targetDir/references.bib" "$sourceDir/$format.bib"
        cp -f "$sourceDir/acronyms.tex" "$targetDir/acronyms.tex"
      '';
    })
  ];
}
