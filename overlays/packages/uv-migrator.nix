{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "uv-migrator";
  version = "2025.8.2";
  useFetchCargoVendor = true;
  # nix-update --flake uv-migrator

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${version}";
    hash = "sha256-ZrHMCfkNz+Ufae1Ylze4poPtYSb8PvW56juR3iLYIOk=";
  };

  cargoHash = "sha256-0t18fKYOp6qF+V24tPLK9IUUYp8OTghlT4j3qxqc9kw=";

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
  };
}
