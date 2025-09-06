{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.54.0";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-klG28flqVHGYDb4xbhI6V+gsdkjFxEs+XhjZnniYphQ=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
  passthru.updateScript = nix-update-script { };
}
