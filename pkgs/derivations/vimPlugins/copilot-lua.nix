{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0-unstable-2026-01-18";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "2d7511494245129aa6c2176f9c71cc2bc1360ed9";
    hash = "sha256-RWkF6t0s4Fd9p66M9Cr/boek0dZCX1rdw5CcKmp+PUA=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
