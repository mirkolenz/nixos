{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "1ff8ab7baae8dab4a9e078350624374cff0d5e71";
    hash = "sha256-S5MnN+8Pjv5RDW9ZrS/3RMNgBWtiy9gbPd2xRoT27ME=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
