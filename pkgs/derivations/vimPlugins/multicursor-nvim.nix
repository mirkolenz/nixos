{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "multicursor.nvim";
  version = "0-unstable-2026-03-24";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "704b99f10a72cc05d370cfeb294ff83412a8ab55";
    hash = "sha256-JHl8Z7ESrWus2I6Pe+6gmdgCAZOzAKX7kimy71sAoe4=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
  strictDeps = true;
}
