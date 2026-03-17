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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZpoRHEcvl/np3JHhGh1E9MBMKWyKd7jQTeNk3PwhaLA=";
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-U4F+HjR4Bwjyj7dZU/XV77Gj3qjCUmeqh7XYYqmhzVI=";

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
