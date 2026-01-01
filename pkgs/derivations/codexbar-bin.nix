{
  mkApp,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
}:
mkApp (finalAttrs: {
  pname = "codexbar";
  version = "0.17.0";
  appname = "CodexBar";

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-${finalAttrs.version}.zip";
    hash = "sha256-LD86SQCPLi/yZOSjatAntcFA1hwzGsLnrOLB/5sMadw=";
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
