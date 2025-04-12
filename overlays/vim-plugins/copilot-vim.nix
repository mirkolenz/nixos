{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.45.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-626maMAOOO9COWHb4ihcY/5AHHSnDcbELVLwk/f/waY=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
