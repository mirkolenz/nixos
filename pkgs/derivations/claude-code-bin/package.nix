{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  makeBinaryWrapper,
  installShellFiles,
  writeScript,
  updateChannel ? "latest",
  manifestFile ? ./manifest.json,
}:
let
  gcsBucket = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  manifest = lib.importJSON manifestFile;
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };
  platform = platforms.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-code";
  version = manifest.version or "unstable";

  src = fetchurl {
    url = "${gcsBucket}/${finalAttrs.version}/${platform}/claude";
    sha256 = manifest.platforms.${platform}.checksum;
  };

  dontUnpack = true;
  dontBuild = true;
  __noChroot = stdenvNoCC.isDarwin;

  # otherwise the bun runtime is executed instead of the binary (on linux)
  dontStrip = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isElf [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    installBin $src
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = writeScript "update-claude-code" ''
    #!/usr/bin/env nix-shell
    #!nix-shell --pure -i bash -p curl jq cacert

    set -euo pipefail

    # https://claude.ai/install.sh
    version="$(curl -fsSL "${gcsBucket}/${updateChannel}")"
    manifest="$(
      curl -fsSL "${gcsBucket}/$version/manifest.json" \
      | jq '{
        version,
        platforms: .platforms | with_entries(
          select(.key | test("^(darwin|linux)-(x64|arm64)$"))
          | {
            key,
            value: { checksum: .value.checksum }
          }
        )
      }'
    )"
    echo "$manifest" > "${toString manifestFile}"
  '';

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    changelog = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "claude";
    platforms = lib.attrNames platforms;
  };
})
