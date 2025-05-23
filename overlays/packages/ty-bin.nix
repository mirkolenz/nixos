{
  lib,
  fetchzip,
  stdenv,
  autoPatchelfHook,
  versionCheckHook,
}:
let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  pname = "ty";
  version = "0.0.1-alpha.6";
  # prefetch-attrs .#ty-bin.passthru.urls --unpack

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/astral-sh/ty/releases/download/${version}/ty-aarch64-apple-darwin.tar.gz";
      aarch64-linux = "https://github.com/astral-sh/ty/releases/download/${version}/ty-aarch64-unknown-linux-gnu.tar.gz";
      x86_64-darwin = "https://github.com/astral-sh/ty/releases/download/${version}/ty-x86_64-apple-darwin.tar.gz";
      x86_64-linux = "https://github.com/astral-sh/ty/releases/download/${version}/ty-x86_64-unknown-linux-gnu.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-z8keMzY0spks9HwdkJAkNtRdj+8thqx0lfPToDnQ/8A=";
      aarch64-linux = "sha256-TAh4vd5IbHXaz86jnrBsByZRHGi5mRieMclaT/gFGeo=";
      x86_64-darwin = "sha256-loQKv+Qm6DK1d5tp3eryCXO6ffCO4I28mGmrlGuQ+00=";
      x86_64-linux = "sha256-7imNhgtQ9MkgaiLJ6rqDeeTiTk45CfmLD3vsbTU9f1o=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };

  buildInputs = lib.optional (!stdenv.isDarwin) (lib.getLib stdenv.cc.cc);

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;

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
