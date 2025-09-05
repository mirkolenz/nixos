{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uv-migrator";
  version = "2025.8.3";
  useFetchCargoVendor = true;

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m/0bNzTSyO2ZgjUAGDjAy6VuSP+czTAa/wqiBOqTOhU=";
  };

  cargoHash = "sha256-kmCzI1LB9MFrZjXnU70QBm83sKcFdWkYR0vFmbiTYAE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
    githubActionsCheck = true;
  };
})
