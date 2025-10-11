{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "multicursor.nvim";
  version = "0-unstable-2025-09-27";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "0c6ceae228bf209e8b8717df9de500770c4e7022";
    hash = "sha256-QhYUwFGYXoeXr2dRraHvpYx4z/7R9TyL9OC2sGmIAMY=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
