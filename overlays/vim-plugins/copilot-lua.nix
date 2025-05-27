{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  # prefetch-attr .#vimPlugins.copilot-lua.src.url --unpack
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "a620a5a97b73faba009a8160bab2885316e1451c";
    hash = "sha256-XxkHZNHInzyCcvB+R/6zRR4pKyjYGvdaNhK34iyef1g=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
