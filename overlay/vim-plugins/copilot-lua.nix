{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0-unstable-2025-09-25";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "e7dabfd5470cf5828d0d7dbc20687ef1c5652614";
    hash = "sha256-CA7S44K1P2usFNaikA5SyOhbG8XrqRmbD/z8Lgy165Y=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
