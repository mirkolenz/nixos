{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.48.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-dWkmdjcpZyd45QTErkUQb1cgbyCYhxfXJUdYz2PO04E=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
