{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "dc579f98536029610cfa32c6bad86c0d24363679";
    hash = "sha256-PaWWT0mSsTfnBMrmHagHgemGN5Be6rbikVVW4ZBK/Zs=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
