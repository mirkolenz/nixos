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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PuD9go5aQJh3qOjWxRX1+43SfHfRcYEulvJ2Mc1lfus=";
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-96hcuvsrtFrQgP2CDLEdssvxXFg9Iy00v1DiJJxkdOU=";

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/zuban
    cp -r third_party $out/${python3.sitePackages}/zuban/
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Python Type Checker / Language Server";
    homepage = "https://github.com/zubanls/zuban";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "zuban";
  };
})
