{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "7ba73866b9b3c696f80579c470c6eec374d3acec";
    hash = "sha256-PDFqHMgYG7RDWVV54Tjh6Vv6B3usS0sSCrFKmIaMzGQ=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
