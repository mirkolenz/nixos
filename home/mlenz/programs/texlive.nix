{
  pkgs,
  config,
  inputs,
  ...
}:
{
  custom.texlive = {
    enable = pkgs.stdenv.isDarwin;
    package =
      let
        prPkgs = import inputs.nixpkgs-texlive {
          inherit (pkgs) system;
        };
      in
      prPkgs.texliveFull;
    bibFolder = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
    texmfFolder = "${config.home.homeDirectory}/Developer/mirkolenz/texmf";
    latexmkrc = ''
      # 1: pdflatex
      # 4: lualatex
      # 5: xelatex
      $pdf_mode = 1;

      # Regular
      $pdflatex = "pdflatex %O %S";
      $xelatex = "xelatex %O %S";
      $lualatex = "lualatex %O %S";

      # Shell escape
      # $pdflatex = "pdflatex -shell-escape %O %S";
      # $xelatex = "xelatex -shell-escape %O %S";
      # $lualatex = "lualatex -shell-escape %O %S";

      # Texmf path
      # $ENV{"TEXINPUTS"} = "./texmf//:" . $ENV{"TEXINPUTS"};
      # $ENV{"BSTINPUTS"} = "./texmf//:" . $ENV{"BSTINPUTS"};
      # $ENV{"BIBINPUTS"} = "./texmf//:" . $ENV{"BIBINPUTS"};

      $postscript_mode = $dvi_mode = 0;
      $clean_ext = "";
      $ENV{"TZ"} = "Europe/Berlin";
    '';
  };
}
