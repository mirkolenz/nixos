{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "copilot.lua";
  version = "0-unstable-2026-02-24";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "ef4bfc579b404c531c1738bacca82ed61501d877";
    hash = "sha256-2z/NsrZuZqsb9wSMhQA1mMjoLCOU98MqM/s2G5/BNaw=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot.lua/";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
}
