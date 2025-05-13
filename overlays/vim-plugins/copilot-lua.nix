{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "2fe34db04570f6c47db0b752ca421a49b7357c03";
    hash = "sha256-TDoBdS7M6R/4/OdAbCiyZz6MHNwQXp/V3tgY9cPfmmA=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
