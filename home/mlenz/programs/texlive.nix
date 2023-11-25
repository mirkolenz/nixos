{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.texlive;

  acronymPresetToList = lib.mapAttrsToList (name: value: "${name}=${value}");
  acronymReplacements =
    lib.mapAttrsToList
    (name: preset: "sd -F 'preset=${name}' '${lib.concatStringsSep ", " (acronymPresetToList preset)}'")
    cfg.acronymPresets;

  cmdTexts = {
    texmfup = ''
      rm -rf ./texmf
      mkdir ./texmf
      ${lib.getExe pkgs.curl} --location https://github.com/mirkolenz/texmf/archive/refs/heads/main.tar.gz \
        | ${lib.getExe pkgs.gnutar} xz --strip-components=1 --directory="./texmf"
    '';
    latexmkrc = ''
      exec cat ${../files/.latexmkrc} > "''${1:-.latexmkrc}"
    '';
    bibtidy = ''
      ${lib.getExe pkgs.bibtex-tidy} --v2 \
        --no-align --no-wrap --blank-lines --no-escape \
        --omit="${lib.concatStringsSep "," cfg.bibtidyOmit}" \
        --max-authors="${builtins.toString cfg.bibtidyMaxAuthors}" \
        "$@"
    '';
    bibcat = ''
      format="''${1:-bibtex}"
      sourceDir="''${2:-${cfg.bibFolder}}"
      ${lib.getExe cmds.bibtidy} "$sourceDir/$format.bib"
    '';
    bibcopy = ''
      format="''${1:-bibtex}"
      sourceDir="''${2:-${cfg.bibFolder}}"
      targetDir="''${3:-.}"
      ${lib.getExe cmds.bibtidy} --output="$targetDir/references.bib" "$sourceDir/$format.bib"
      ${lib.getExe cmds.acrocat} "$sourceDir" > "$targetDir/acronyms.tex"
    '';
    acrocat = ''
      sourceDir="''${1:-${cfg.bibFolder}}"
      # shellcheck disable=SC2002 # the sd commands are generated via nix, so cat is more elegant than piping
      cat "$sourceDir/acronyms.tex" | ${lib.concatStringsSep " | " acronymReplacements}
    '';
  };

  cmds = lib.mapAttrs (name: text: pkgs.writeShellApplication {inherit name text;}) cmdTexts;
in {
  options = {
    custom.texlive = {
      enable = lib.mkEnableOption "TeX Live";

      package = lib.mkOption {
        type = lib.types.package;
        description = "TeX Live package set to use.";
        default = pkgs.texliveFull;
        defaultText = lib.literalExpression "pkgs.texliveFull";
      };

      bibFolder = lib.mkOption {
        type = lib.types.str;
        description = "Location of the bibliography files.";
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Extra TeX Live packages to install.";
        default = with pkgs; [
          stable.tectonic
          texlab
          bibtex2cff
          bibtexbrowser2cff
          bibtex-tidy
        ];
      };

      acronymPresets = lib.mkOption {
        type = lib.types.attrs;
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
        type = lib.types.listOf lib.types.str;
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
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        [cfg.package]
        ++ cfg.extraPackages
        ++ (builtins.attrValues cmds);
      file = {
        ".latexmkrc".source = ../files/.latexmkrc;
        "texmf".source = builtins.toString inputs.texmf;
      };
    };
  };
}
