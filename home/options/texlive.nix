{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.texlive;

  acronymPresetToList = lib.mapAttrsToList (name: value: "${name}=${value}");
  acronymReplacements = lib.mapAttrsToList (
    name: preset: "sd -F 'preset=${name}' '${lib.concatStringsSep ", " (acronymPresetToList preset)}'"
  ) cfg.acronymPresets;

  cmdTexts = {
    texmfup = ''
      rm -rf ./texmf
      mkdir ./texmf
      ${lib.getExe pkgs.curl} --location https://github.com/mirkolenz/texmf/archive/refs/heads/main.tar.gz \
        | ${lib.getExe pkgs.gnutar} xz --strip-components=1 --directory="./texmf"
    '';
    latexmkrc = ''
      exec cp -f ${config.home.file.".latexmkrc".source} "''${1:-.latexmkrc}"
    '';
    bibtidy = ''
      ${lib.getExe pkgs.bibtex-tidy} --v2 \
        --no-align --no-wrap --blank-lines --no-escape \
        --omit="${lib.concatStringsSep "," cfg.bibtidyOmit}" \
        --max-authors="${toString cfg.bibtidyMaxAuthors}" \
        "$@"
    '';
    bibcat = ''
      format="''${1:-bibtex}"
      sourceDir="''${2:-${cfg.bibDir}}"
      ${lib.getExe cmds.bibtidy} "$sourceDir/$format.bib"
    '';
    bibcopy = ''
      format="''${1:-bibtex}"
      sourceDir="''${2:-${cfg.bibDir}}"
      targetDir="''${3:-.}"
      ${lib.getExe cmds.bibtidy} --output="$targetDir/references.bib" "$sourceDir/$format.bib"
      ${lib.getExe cmds.acrocat} "$sourceDir" > "$targetDir/acronyms.tex"
    '';
    bibcopy-full = ''
      format="''${1:-bibtex}"
      sourceDir="''${2:-${cfg.bibDir}}"
      targetDir="''${3:-.}"
      ${lib.getExe pkgs.bibtex-tidy} --v2 \
        --no-align --no-wrap --blank-lines --no-escape \
        --omit="abstract" \
        --output="$targetDir/references.bib" \
        "$sourceDir/$format.bib"
      ${lib.getExe cmds.acrocat} "$sourceDir" > "$targetDir/acronyms.tex"
    '';
    acrocat = ''
      sourceDir="''${1:-${cfg.bibDir}}"
      # shellcheck disable=SC2002 # the sd commands are generated via nix, so cat is more elegant than piping
      cat "$sourceDir/acronyms.tex" | ${lib.concatStringsSep " | " acronymReplacements}
    '';
  };

  cmds = lib.mapAttrs (name: text: pkgs.writeShellApplication { inherit name text; }) cmdTexts;
in
{
  options = {
    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/texlive.section.md
    custom.texlive = {
      enable = lib.mkEnableOption "TeX Live";

      package = lib.mkPackageOption pkgs "TeX Live Scheme" {
        default = [ "texliveFull" ];
        example = "pkgs.texliveSmall";
      };

      bibDir = lib.mkOption {
        type = lib.types.str;
        description = "Location of the bibliography files.";
      };

      latexmkrc = lib.mkOption {
        type = lib.types.lines;
        description = "Content of the .latexmkrc file.";
      };

      extraPackages = lib.mkOption {
        type = with lib.types; listOf package;
        description = "Extra TeX Live packages to install.";
        default = with pkgs; [
          tectonic
          texlab
          bibtex2cff
          bibtexbrowser2cff
          bibtex-tidy
          arxiv-latex-cleaner
          tex-fmt
        ];
      };

      acronymPresets = lib.mkOption {
        type = with lib.types; attrsOf anything;
        description = "Acronym presets to use.";
        default = {
          short = {
            first-style = "short";
            long = "{}";
          };
        };
      };

      bibtidyMaxAuthors = lib.mkOption {
        type = lib.types.int;
        description = "Maximum number of authors to display.";
        default = 10;
      };

      bibtidyOmit = lib.mkOption {
        type = with lib.types; listOf str;
        description = "Fields to omit from the bibliography.";
        default = [
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
          "pmcid"
          "pmid"
          "primaryclass"
          "series"
          "url"
          "urldate"
          "volume"
          # "eprinttype"
          # "pages"
          # "publisher"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.singleton cfg.package ++ cfg.extraPackages ++ (builtins.attrValues cmds);
      file = {
        ".latexmkrc".source = pkgs.writeText "latexmkrc" cfg.latexmkrc;
      };
    };
  };
}
