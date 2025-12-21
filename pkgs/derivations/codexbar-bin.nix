{
  mkApp,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
}:
mkApp (finalAttrs: {
  pname = "codexbar";
  version = "0.11.2";
  appname = "CodexBar";

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-${finalAttrs.version}.zip";
    hash = "sha256-iZvxCkOIxL4T+qj47JJQrCJF2IXL1GghLcXOMQNCq+k=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=${finalAttrs.meta.homepage}" ];
  };

  meta = {
    description = "Show usage stats for OpenAI Codex and Claude Code";
    homepage = "https://github.com/steipete/CodexBar";
    downloadPage = "https://github.com/steipete/CodexBar/releases";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
  };
})
