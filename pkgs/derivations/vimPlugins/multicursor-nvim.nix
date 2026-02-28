{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "multicursor.nvim";
  version = "0-unstable-2026-02-27";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "3b9e9d69960028f42c72fa853775373fcdb31f22";
    hash = "sha256-1SPple+9eB5aW08juVHuEpVdPpKvjwgdbJo0LtiCGgU=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
