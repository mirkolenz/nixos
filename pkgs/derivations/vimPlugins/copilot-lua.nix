{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0-unstable-2026-02-06";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "3faffefbd6ddeb52578535ec6b730e0b72d7fd1a";
    hash = "sha256-pZjz2W9DERdHHNJS6ilLsfnCIdB7N0NaDYxjcyOvTKU=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
