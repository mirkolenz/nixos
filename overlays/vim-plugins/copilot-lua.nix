{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "0b435497295f01e253f3c1777e02f4553da7f59d";
    hash = "sha256-MOiOshucH+h/Xf8PWZGA2g4+VGfAVVIRrq77dYGNnUE=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
