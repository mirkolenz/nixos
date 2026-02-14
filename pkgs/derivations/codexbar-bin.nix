{
  mkApp,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
}:
mkApp (finalAttrs: {
  pname = "codexbar";
  version = "0.18.0-beta.3";
  appname = "CodexBar";

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-${finalAttrs.version}.zip";
    hash = "sha256-OAbpuMHGwSuMfS5gtryv8+Z3vDnsQNrej8TunellaP0=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  wrapperPath = "Contents/Helpers/CodexBarCLI";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "Show usage stats for OpenAI Codex and Claude Code";
    homepage = "https://github.com/steipete/CodexBar";
    downloadPage = "https://github.com/steipete/CodexBar/releases";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
  };
})
