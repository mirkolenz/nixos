{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
  versionCheckHook,
  binariesFromGitHub,
  installShellFiles,
  buildFHSEnv,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  release = lib.importJSON ./release.json;
  systemToPlatform = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };
  platform = systemToPlatform.${system};
  assetName = "copilot-language-server-${platform}-${release.version}.zip";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "copilot-language-server";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/github/copilot-language-server-release/releases/download/${finalAttrs.version}/${assetName}";
    hash = release.hashes.${assetName};
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    installShellFiles
  ];

  # autoPatchElfHook causes Node.js SyntaxError: Invalid or unexpected token

  dontConfigure = true;
  dontBuild = true;

  # Pkg: Error reading from file.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    installBin copilot-language-server

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = false;

  passthru.updateScript = binariesFromGitHub {
    owner = "github";
    repo = "copilot-language-server-release";
    outputFile = ./release.json;
    assetsPattern = ''^copilot-language-server-(linux|darwin)-(arm64|x64)-\($release.tag_name)\\.zip$'';
  };

  passthru.fhs = buildFHSEnv {
    inherit (finalAttrs) pname version;
    targetPkgs = pkgs: [ pkgs.stdenv.cc.cc.lib ];
    runScript = lib.getExe finalAttrs.finalPackage;
    meta = finalAttrs.meta // {
      description = "${finalAttrs.meta.description} (Use this version if you encounter an error like `Could not start dynamically linked executable` or `SyntaxError: Invalid or unexpected token`)";
    };
  };

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/github/copilot-language-server-release";
    downloadPage = "https://github.com/github/copilot-language-server-release/releases";
    mainProgram = "copilot-language-server";
    platforms = lib.attrNames systemToPlatform;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
})
