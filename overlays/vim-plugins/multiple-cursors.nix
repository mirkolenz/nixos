{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "multiple-cursors.nvim";
  version = "0.15";
  src = fetchFromGitHub {
    owner = "brenton-leighton";
    repo = "multiple-cursors.nvim";
    tag = "v${version}";
    hash = "sha256-iTtohxL1uJu/KGGvZsnHfqPLj8EaGy1d30I+lHkJaRE=";
  };
  meta.homepage = "https://github.com/brenton-leighton/multiple-cursors.nvim";
  passthru.updateScript = nix-update-script { };
}
