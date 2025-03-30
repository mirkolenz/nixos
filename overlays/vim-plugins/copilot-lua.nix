{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "d661d65b4cab20a5c164f6d9081d91ed324fe4d8";
    hash = "sha256-Sx5rasRT6IFx96jbFqzrpRblDQsVtaWnFv/swVnQGdI=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
