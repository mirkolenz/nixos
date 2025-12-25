{
  mkApp,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
}:
mkApp (finalAttrs: {
  pname = "codexbar";
  version = "0.13.0";
  appname = "CodexBar";

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-${finalAttrs.version}.zip";
    hash = "sha256-5jj/DXPpq/r49IuEAnoJhPUe0s/yTBVjtvi2F6BsTjk=";
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
