{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "multicursor.nvim";
  version = "0-unstable-2025-05-29";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "6fba38bccf45cfb681f4ff6098f886213f299a34";
    hash = "sha256-NUOJlFZhB8OqBlkp+dXUQzFTHvPCMmWFMMTWmV7XdLQ=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
