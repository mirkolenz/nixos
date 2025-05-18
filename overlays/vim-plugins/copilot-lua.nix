{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  # prefetch-attr .#vimPlugins.copilot-lua.src.url --unpack
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "0929c92097a49b6ae3565aab157fa2bce398d953";
    hash = "sha256-pz9T3W/TbXVpXdef9bMEqZxMfBA2Y5esINrAmLwgiqw=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
