{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.57.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-Ng7ENFY1LxFvVwwxSXbtnhYkN6JQQ+9DT+thKb2sJCE=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
  passthru.updateScript = nix-update-script { };
}
