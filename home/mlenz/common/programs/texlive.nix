{
  pkgs,
  config,
  lib,
  ...
}:
# https://tug.org/texlive/scripts-sys-user.html
lib.mkIf pkgs.stdenv.isDarwin {
  custom.texlive = {
    enable = true;
    bibDir = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
    latexmkrc = ''
      # 1: pdflatex
      # 4: lualatex
      $pdf_mode = 1;

      @default_files = ("main.tex");

      # add `-shell-escape` if needed
      $pdflatex = "pdflatex %O %S";
      $lualatex = "lualatex %O %S";

      # inject local texmf if needed
      # ensure_path("TEXINPUTS", "./texmf//");
      # ensure_path("BSTINPUTS", "./texmf//");
      # ensure_path("BIBINPUTS", "./texmf//");

      # set timezone
      $ENV{"TZ"} = "Europe/Berlin";

      # force compilation
      $go_mode = 3;

      # force bibtex
      $bibtex_use = 2;

      # system-specific
      $pdf_previewer = "open -g -a Skim %S";
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
