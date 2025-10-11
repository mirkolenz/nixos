{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uv-migrator";
  version = "2025.9.0";

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0N3/zxmnulzM5aXz5nlOr/GWE5rOm3OPb5wFmK1Eeww=";
  };

  cargoHash = "sha256-6VdroqLK4z/bCX8lOaEARlmYJ82qf2x6p+6pp8seSfk=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
  };
})
