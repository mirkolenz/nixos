{
  lib,
  fetchzip,
  stdenvNoCC,
  autoPatchelfHook,
  versionCheckHook,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
in
stdenvNoCC.mkDerivation rec {
  pname = "ty";
  version = "0.0.1-alpha.1";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/astral-sh/ty/releases/download/${version}/ty-aarch64-apple-darwin.tar.gz";
      aarch64-linux = "https://github.com/astral-sh/ty/releases/download/${version}/ty-aarch64-unknown-linux-gnu.tar.gz";
      x86_64-darwin = "https://github.com/astral-sh/ty/releases/download/${version}/ty-x86_64-apple-darwin.tar.gz";
      x86_64-linux = "https://github.com/astral-sh/ty/releases/download/${version}/ty-x86_64-unknown-linux-gnu.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-dYMSkvl91yVgtSoZR324f6RGh3llz67kEnLuodM0o/8=";
      aarch64-linux = "sha256-fs/nAkhdGYWPZiXwSEYoU3mnglRVCyBWNGi57rtGk8E=";
      x86_64-darwin = "sha256-4CijJVoLlg89ybayLtKg5bv4bbgprfJ9pYYck3NOqUs=";
      x86_64-linux = "sha256-3uVH68u+EVe33oo24yWfg1iCkbZQF8mWfpyZZz4Kd88=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };

  nativeBuildInputs = lib.optional (!stdenvNoCC.isDarwin) autoPatchelfHook;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D ty $out/bin/ty

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "An extremely fast Python type checker and language server, written in Rust";
    homepage = "https://github.com/astral-sh/ty";
    downloadPage = "https://github.com/astral-sh/ty/releases";
    mainProgram = pname;
    platforms = lib.attrNames passthru.urls;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
  };
}
