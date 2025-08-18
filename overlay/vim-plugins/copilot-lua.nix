{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0-unstable-2025-08-17";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "3fd7b50810ae4cccf8b38e4c509b1608f141a9e9";
    hash = "sha256-KV+Wno4aB5uTSBxIZzQKC/0KfjQLM7x8wCDkVSnaPeA=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
