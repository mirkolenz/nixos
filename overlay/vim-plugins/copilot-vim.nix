{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.52.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-c7t/U8oFKVryK2+ypy3dgiYTYvYnxmhtve1h6tLg/qM=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
  passthru.updateScript = nix-update-script { };
}
