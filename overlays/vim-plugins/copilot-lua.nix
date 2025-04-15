{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "cf6cb4f3d7f2729263fc2130de609ff5af22702a";
    hash = "sha256-fDzahAiqVZQ4SWgaqAwXEAOF9KjTKjdJqf0BPkcDoJ4=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
}
