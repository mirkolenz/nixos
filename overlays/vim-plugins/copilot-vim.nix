{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.46.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-wWimUJZKAEuHFf5TI898IAR/6XsL53hf25s9rvIpA58=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
