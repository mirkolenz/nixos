{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zuban";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QQpv6NPHP1by0ERF7hUPNiZ3qi7t8ovQB5UdAA7pZ08=";
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-xP93DTkEWbBTCNN/y/vP3k+W11taa7VQbF4ZbP2n4sM=";

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/zuban
    cp -r third_party $out/${python3.sitePackages}/zuban/
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  strictDeps = true;

  meta = {
    description = "Python Type Checker / Language Server";
    homepage = "https://github.com/zubanls/zuban";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "zuban";
  };
})
