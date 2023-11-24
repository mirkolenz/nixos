{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; let
    bibFolder = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
  in [
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
          "chapter"
          "copyright"
          "doi"
          "edition"
          "editor"
          "eprint"
          "googlebooks"
          "isbn"
          "issn"
          "langid"
          "language"
          "lccn"
          "month"
          "number"
          "pages"
          "pmcid"
          "pmid"
          "primaryclass"
          "publisher"
          "series"
          "url"
          "urldate"
          "volume"
          # "eprinttype"
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
        sourceDir="''${2:-${bibFolder}}"
        targetDir="''${3:-.}"
        bibtidy --output="$targetDir/references.bib" "$sourceDir/$format.bib"
        acrocat "$sourceDir" > "$targetDir/acronyms.tex"
      '';
    })
    (pkgs.writeShellApplication {
      name = "bibcat";
      text = ''
        format="''${1:-bibtex}"
        sourceDir="''${2:-${bibFolder}}"
        bibtidy "$sourceDir/$format.bib"
      '';
    })
    (pkgs.writeShellApplication {
      name = "acrocat";
      text = let
        presets = {
          sentity = {
            short-format = "\\ttfamily";
            first-style = "short";
            long = "{}";
          };
          entity = {
            short-format = "\\ttfamily";
          };
          short = {
            first-style = "short";
            long = "{}";
          };
        };
        presetToList = lib.mapAttrsToList (name: value: "${name}=${value}");
        replacements =
          lib.mapAttrsToList
          (name: preset: "sd -F 'preset=${name}' '${lib.concatStringsSep ", " (presetToList preset)}'")
          presets;
      in ''
        sourceDir="''${1:-${bibFolder}}"
        # shellcheck disable=SC2002 # the sd commands are generated via nix, so cat is more elegant than piping
        cat "$sourceDir/acronyms.tex" | ${lib.concatStringsSep " | " replacements}
      '';
    })
  ];
}
