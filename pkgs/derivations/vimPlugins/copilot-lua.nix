{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot.lua";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "v${version}";
    hash = "sha256-RzHCniW/n796uYdVA1LtHWBI3XxoPgmdw2N8RpUjPJQ=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script { };
}
