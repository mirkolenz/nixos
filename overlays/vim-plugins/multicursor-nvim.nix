{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "c731e52cee7b69fa05915affb09ba65e7cd31fa9";
    hash = "sha256-rw7jE89Lj5F7bOCAx/rMO+Dpswfg9ohKDyQ3RJtaa3I=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
