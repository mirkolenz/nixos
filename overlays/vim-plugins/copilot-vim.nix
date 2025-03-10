{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.43.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-IPLaF6qqhMst9uO6QmJV2Y5/MMw15qA//jM0BWz1FaU=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
