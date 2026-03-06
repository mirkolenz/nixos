{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "2.0.0-unstable-2026-03-06";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "437b18f7db78a0ec2bea05dde37791019913e547";
    hash = "sha256-ix+dR/sho4a1f4EliUMWkB396NbPLb7C9t+jN8fiviA=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
