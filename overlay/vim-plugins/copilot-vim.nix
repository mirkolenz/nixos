{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.56.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-dL+yxTPSjX5PDJ4LgqFoS1HtkZV9G1S6VD+w+CPhil8=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
  passthru.updateScript = nix-update-script { };
}
