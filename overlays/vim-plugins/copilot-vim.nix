{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.49.0";
  # prefetch-attr .#vimPlugins.copilot-vim.src.url --unpack
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-L00j3oqs7Bqg3cxjfh2Al8VpgMhriLxmQN0HZaGrujI=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
