{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot.lua";
  version = "3.1.5";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "v${version}";
    hash = "sha256-/f20KI5XtjnEr8tOBqGy+X9RM7sc9pLn1uq5bIEQC1k=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script { };
  strictDeps = true;
}
