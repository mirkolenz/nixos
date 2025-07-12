{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  custom.texlive = {
    enable = true;
    bibDir = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
    latexmkrc = ''
      # 1: pdflatex
      # 4: lualatex
      # 5: xelatex
      $pdf_mode = 1;

      @default_files = ("main.tex");

      # Add -shell-escape if needed
      $pdflatex = "pdflatex %O %S";
      $xelatex = "xelatex %O %S";
      $lualatex = "lualatex %O %S";

      # Inject local texmf
      # $ENV{"TEXINPUTS"} = "./texmf//:" . $ENV{"TEXINPUTS"};
      # $ENV{"BSTINPUTS"} = "./texmf//:" . $ENV{"BSTINPUTS"};
      # $ENV{"BIBINPUTS"} = "./texmf//:" . $ENV{"BIBINPUTS"};

      # Only for system config
      $ENV{"TZ"} = "Europe/Berlin";
      $clean_ext = "";
      $pdf_previewer = "open -a Skim %S";
    '';
  };
  home.packages = with pkgs; [
    arxiv-latex-cleaner
    bibtex-tidy
    bibtex2cff
    bibtexbrowser2cff
    ltex-ls-plus
    sioyek-bin
    tectonic
    texlab
    zathura
  ];
}
