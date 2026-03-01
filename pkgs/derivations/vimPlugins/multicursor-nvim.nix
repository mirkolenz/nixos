{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "multicursor.nvim";
  version = "0-unstable-2026-02-28";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "811681faf44d8031685614cc00a148cd3ece697c";
    hash = "sha256-5Syxir+5cKzpr9cEDGm2AWILJ40lsTObuOwMVxV+znE=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
