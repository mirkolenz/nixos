{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0-unstable-2025-09-27";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "619493a538c140393f0c80fd386144e0b5d3b96f";
    hash = "sha256-+HyQWYo5Lr/mgP9/gfxlhziEQ9VCf3HTNgoFw/nKIuA=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
