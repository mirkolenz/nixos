{
  lib,
  stdenv,
  unzip,
  versionCheckHook,
  mkGitHubBinary,
  installShellFiles,
}:
let
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };
in
mkGitHubBinary (finalAttrs: {
  pname = "copilot-language-server";
  owner = "github";
  repo = "copilot-language-server-release";
  file = ./release.json;
  getAsset = { version, system }: "copilot-language-server-${platforms.${system}}-${version}.zip";
  pattern = ''^copilot-language-server-(linux|darwin)-(arm64|x64)-\($release.tag_name)\\.zip$'';

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    installShellFiles
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    stdenv.cc.cc
  ];

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

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    platforms = lib.attrNames platforms;
    license = lib.licenses.unfree;
  };
})
