{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "0ca2ccdec1f10430940f751a2044a0955777f174";
    hash = "sha256-NcQszrisuVlcKkSOELD475NkaGFIx+m2ndBLQFMxhfI=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
