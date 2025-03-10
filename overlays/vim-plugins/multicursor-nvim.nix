{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "58b3ec99a3d25a99afd9531d475d05c776276faa";
    hash = "sha256-5otx0ATg56t9pnACgWyEZ+L72zzJ25BEQRdTCR2s4NE=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
