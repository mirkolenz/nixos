{
  lib,
  stdenvNoCC,
  unzip,
  versionCheckHook,
  mkGitHubBinary,
  installShellFiles,
  buildFHSEnv,
}:
let
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };
  ghBin = mkGitHubBinary {
    pname = "copilot-language-server";
    owner = "github";
    repo = "copilot-language-server-release";
    file = ./release.json;
    getAsset =
      { version, system, ... }: "copilot-language-server-${platforms.${system}}-${version}.zip";
    assetsPattern = ''^copilot-language-server-(linux|darwin)-(arm64|x64)-\($release.tag_name)\\.zip$'';
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (ghBin) pname version src;

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
  doInstallCheck = true;

  passthru = ghBin.passthru // {
    fhs = buildFHSEnv {
      inherit (finalAttrs) pname version;
      targetPkgs = pkgs: [ pkgs.stdenv.cc.cc.lib ];
      runScript = lib.getExe finalAttrs.finalPackage;
      meta = finalAttrs.meta // {
        description = "${finalAttrs.meta.description} (Use this version if you encounter an error like `Could not start dynamically linked executable` or `SyntaxError: Invalid or unexpected token`)";
      };
    };
  };

  meta = ghBin.meta // {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/github/copilot-language-server-release";
    downloadPage = "https://github.com/github/copilot-language-server-release/releases";
    mainProgram = "copilot-language-server";
    platforms = lib.attrNames platforms;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    githubActionsCheck = true;
  };
})
