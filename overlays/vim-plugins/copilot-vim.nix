{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.44.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-1l8BU7gwBVHy6DrXijq82fzR7aVWe7zEIsOOUPxRpyQ=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
