{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uv-migrator";
  version = "2025.8.2";
  useFetchCargoVendor = true;

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZrHMCfkNz+Ufae1Ylze4poPtYSb8PvW56juR3iLYIOk=";
  };

  cargoHash = "sha256-0t18fKYOp6qF+V24tPLK9IUUYp8OTghlT4j3qxqc9kw=";

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
