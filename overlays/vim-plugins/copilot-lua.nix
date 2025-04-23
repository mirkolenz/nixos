{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "089ec63c91e66368dbe1026bf2eb70fd7dc52884";
    hash = "sha256-q/S1BQ/HCZs0W3GCqgcTdltF3bhrF38ejeNc9DbQO7I=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
