{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "0e00ce4c272e3191b5e07cab36bd49aa32fca675";
    hash = "sha256-ZV4/QolvzaxV0SoPwO3Orf3HCJGD2+J15WKRUe0Hauw=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
