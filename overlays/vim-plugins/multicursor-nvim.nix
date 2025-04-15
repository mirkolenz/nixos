{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "f3a4899e5cdc93e6f8cd06bbc3b3631a2e85a315";
    hash = "sha256-vJpXveXQvS25jxYSfBVifwANe43QCDHEgsD657pre9o=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
